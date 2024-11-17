import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectf/homepage.dart';
import 'package:projectf/utlis/utils.dart';

import 'about.dart';
import 'drawer.dart';


class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  CameraController? _cameraController;
  String? _prediction;
  Timer? _timer;
  XFile? _imageFile;
  int _closeEyeCount = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late Future<LocationData?> _locationFuture;
  var _closestCity;
  String clcity='loading...';
  String clcityemail='null...';
  Timer? _locationTimer;
  LocationData? _currentLocation;
  late LocationData locationData;
  int i=0;
  User? currentuser=FirebaseAuth.instance.currentUser;
  late List<Color> colors;
  late Timer _timer1;
  int currentIndex = 0;

 String userfirstname='';
 String userlastname='';
 String usernumber='';

  bool _isCameraPaused = false;


  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _locationFuture = getCurrentLocation();
    _initializeLocationUpdates();
    fetchUserData();
    colors = [
      hexStringToColor("#caf0f8"),
      hexStringToColor("#0077b6"),
      hexStringToColor("#00b4d8"),
      hexStringToColor("#caf0f8"),
    ];
    _timer1 = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % colors.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    _locationTimer?.cancel();
    super.dispose();
  }


  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first.data(); // Get the first document data
        setState(() {
          userfirstname = userDoc['firstname'];
          userlastname = userDoc['lastname'];
          usernumber = userDoc['phone'];
        });
      } else {
        print("No user found with the specified email.");
      }
    }
  }

  sendnotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: "basic_channel",
          title: "We Have An Emergency",
          body: "The Driver Could Be a Sleep Or In Danger",
        ));
  }

  void showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _stopCamera() {
    // Stop and dispose the camera controller manually if needed.
    _cameraController?.dispose();
  }

  Future<void> _captureAndUploadImage() async {
    try {
      // Capture image from the camera
      _imageFile = await _cameraController!.takePicture();
      // Load the image for face detection
      final inputImage = InputImage.fromFilePath(_imageFile!.path);
      // Detect faces in the image
      final faceDetector = GoogleMlKit.vision.faceDetector();
      final faces = await faceDetector.processImage(inputImage);
      // Check if any faces are detected
      if (faces.isEmpty) {
        if(i<3)
          {
            showAlert(context, 'No faces detected in the image');
            i++;
          }
        else
          {
            sendnotification();
            LatLng currentLocation = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
            findClosestCity(currentLocation);
            _stopCamera();
            _sendEmail(name:'system',email:clcityemail,
                subject: 'Emergency problem with a driver',
                message: 'there may have been a problem with a driver on site latitude:${locationData.latitude},longitude:${locationData.longitude} and fullname $userfirstname-$userlastname and number $usernumber');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => home()));
          }

      } else {
        final Face face = faces[0];
        // Get the bounding box of the face
        final Rect boundingBox = face.boundingBox;
        // Calculate the center point of the face
        final double centerX = boundingBox.left + (boundingBox.width / 2);
        final double centerY = boundingBox.top + (boundingBox.height / 2);
        // Calculate the size of the eyes region (adjust as needed)
        final double eyesRegionWidth = boundingBox.width * 0.4;
        final double eyesRegionHeight = boundingBox.height * 0.2;
        // Calculate the coordinates of the eyes region
        final double eyesRegionLeft = centerX - (eyesRegionWidth / 2);
        final double eyesRegionTop = centerY - (eyesRegionHeight / 2);
        // Crop the image to extract the eyes region
        final img.Image croppedImage = img.copyCrop(
          img.decodeImage(File(_imageFile!.path).readAsBytesSync())!,
          x: eyesRegionLeft.toInt(),
          y: eyesRegionTop.toInt(),
          width: eyesRegionWidth.toInt(),
          height: eyesRegionHeight.toInt(),
        );
        // Convert the cropped image to a File
        final Directory tempDir = await getTemporaryDirectory();
        final String tempPath = tempDir.path;
        final File croppedFile = File('$tempPath/cropped_image.png');
        await croppedFile.writeAsBytes(img.encodePng(croppedImage));
        // Upload the cropped image
        await _uploadImage(croppedFile);
      }
    } catch (e) {
      print('Error capturing or processing image: $e');
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[1], ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {});
      _startPeriodicCapture();
    } else {
      print('No camera available');
    }
  }

  void _startPeriodicCapture() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await _captureAndUploadImage();

    });
  }

  void _initializeLocationUpdates() {
    _locationTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      _currentLocation = await getCurrentLocation();
      if (_currentLocation != null) {
        LatLng currentLocation = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
        findClosestCity(currentLocation);
        _closestCity = clcity;
        setState(() {});
      }
    });
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final uri = Uri.parse('http://192.168.247.37:5003'); // Replace with your Flask server's IP address
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final responseData = json.decode(responseString);
        setState(() {
          _prediction = responseData['class'];
          _handlePrediction(_prediction!);
        });
        print('Image uploaded successfully.');
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<LocationData?> getCurrentLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    // Check if location services are enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }
    // Check for location permissions
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    // Get the current location
    _locationData = await location.getLocation();

    return _locationData;
  }

  Future<void> _handlePrediction(String prediction) async {
    if (prediction == 'closeeye') {
      _closeEyeCount++;
      if(_closeEyeCount==2)
      {
        final ByteData data = await rootBundle.load('assets/Alarm Clock Sound Effect (Animated)(MP3_160K).mp3');
        final Uint8List bytes = data.buffer.asUint8List();
        await _audioPlayer.play(BytesSource(bytes));
        await Future.delayed(Duration(seconds: 6));
        await _audioPlayer.stop();
      }
      if (_closeEyeCount == 3) {
        final ByteData data = await rootBundle.load('assets/Alarm Clock Sound Effect (Animated)(MP3_160K).mp3');
        final Uint8List bytes = data.buffer.asUint8List();
        await _audioPlayer.play(BytesSource(bytes));
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text("please enter on ok for stop alert"),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _audioPlayer.stop();
                    // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => home()));
        sendnotification();
        LatLng currentLocation = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
        getClosestCityEmail(currentLocation);
        _stopCamera();
        _sendEmail(name:'system',email:clcityemail,
            subject: 'Emergency problem with a driver',
            message: 'the driver may be sleep  on site latitude:${locationData.latitude},longitude:${locationData.longitude} and fullname $userfirstname-$userlastname and number $usernumber');
      }else{
        _closeEyeCount=0;
      }
    }
  }

  Future _sendEmail({required String name,
    required String email,
    required String subject,
    required String message,})
  async {
    print("ysessssssssssssssssssssssssssssssssssssssssssss");
    final serviceId='service_41m25rg';
    final templateId='template_r6mkipy';
    final userId='CzO68so50pwAa7LW0';
    final url=Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response=await http.post(
      url,

      headers:{
        'origin':'http://localhost',
        'Content-Type':'application/json',
      },
      body:json.encode({
        'service_id':serviceId,
        'template_id':templateId,
        'user_id':userId,
        'template_params':{
          'user_name':name,
          'user_email':email,
          'user_subject':subject,
          'user_message':message,
        }

      }),);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.body)),
    );
  }
//////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

  Map<String, LatLng> cities = {
    'City AL_NABK': LatLng(34.0228365699086,36.72809435490094), // Example coordinates for Los Angeles
    'City HILA': LatLng(33.737219780056286, 36.53096556703466), // Example coordinates for Las Vegas
    'City QARA': LatLng(34.15419723008783, 36.74377470686847), // Example coordinates for San Francisco
  };

  double calculateDistance(LatLng start, LatLng end) {
  const double R = 6371; // Radius of the Earth in kilometers
  double latDistance = _toRadians(end.latitude - start.latitude);
  double lonDistance = _toRadians(end.longitude - start.longitude);
  double a = sin(latDistance / 2) * sin(latDistance / 2) +
  cos(_toRadians(start.latitude)) * cos(_toRadians(end.latitude)) *
  sin(lonDistance / 2) * sin(lonDistance / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
  }
  double _toRadians(double degree) {
  return degree * pi / 180;
  }
  Future<String> findClosestCity(LatLng currentLocation) async {
    String closestCity = '';
    double closestDistance = double.infinity;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('cities').get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      LatLng cityLocation = LatLng(data['latitude'], data['longitude']);
      double distance = calculateDistance(currentLocation, cityLocation);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestCity = doc.id;
      }
    }
    clcity=closestCity;
    return closestCity;
  }

  Future<String?> getClosestCityEmail(LatLng currentLocation) async {
    try {
      CollectionReference citiesCollection = FirebaseFirestore.instance.collection('cities');
      QuerySnapshot querySnapshot = await citiesCollection.get();

      if (querySnapshot.docs.isEmpty) {
        print("No cities found in Firebase.");
        return null;
      }

      String? closestCityEmail;
      double closestDistance = double.infinity;

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        double latitude = data['latitude'];
        double longitude = data['longitude'];
        String email = data['email'];

        LatLng cityLocation = LatLng(latitude, longitude);
        double distance = calculateDistance(currentLocation, cityLocation);

        if (distance < closestDistance) {
          closestDistance = distance;
          closestCityEmail = email;
        }
      }
      clcityemail=closestCityEmail!;
      return closestCityEmail;
    } catch (e) {
      print("Error fetching cities from Firebase: $e");
      return null;
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detiction'),
        backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
      ),
      body: _cameraController == null || !_cameraController!.value.isInitialized
          ? Center(child: CircularProgressIndicator())
          : AnimatedContainer(
        duration: Duration(seconds: 1),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.3,
            stops: const [0.3, 1.5, 0.9, 1.8],
            colors: [
              colors[(currentIndex) % colors.length],
              colors[(currentIndex + 1) % colors.length],
              colors[(currentIndex + 2) % colors.length],
              colors[(currentIndex + 3) % colors.length],
            ],
          ),
        ),
            child: Stack(
        children: <Widget>[
            Positioned.fill(bottom: 140,
              child: CameraPreview(_cameraController!),
            ),
            Positioned(
              bottom: 100,
              left: 105,
              child: FutureBuilder<LocationData?>(
                future: _locationFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('Location data not available');
                  } else {
                    locationData = snapshot.data!;
                    LatLng currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
                    findClosestCity(currentLocation);
                    return Text(
                      'Closest City: $_closestCity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 5,),
            Positioned(
              bottom: 70,
              left: 100,
              child: _prediction == null
                  ? Text(
                'No prediction yet.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  backgroundColor:  Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                ),
              )
                  : Text(
                'Prediction: $_prediction',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 130,
              child: ElevatedButton(
                onPressed:()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home())),
                style: ElevatedButton.styleFrom(
                 shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
              ),
                  backgroundColor: Colors.red,
                ),
                child: Text('Pause Camera',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
          ),
      drawer: MyDrawer(width: 300,),
    );
  }
}
class LatLng {
  final double latitude;
  final double longitude;
  LatLng(this.latitude, this.longitude);
}

