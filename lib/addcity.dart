import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectf/reusable_widget/reusable_widget.dart';
import 'dart:math';

import 'package:projectf/utlis/utils.dart';

import 'drawer.dart';

class CityInputScreen extends StatefulWidget {
  @override
  _CityInputScreenState createState() => _CityInputScreenState();
}

class _CityInputScreenState extends State<CityInputScreen> {
  final TextEditingController _idcontroller = TextEditingController();
  final TextEditingController _id_deletecontroller = TextEditingController();
  final TextEditingController _cityNameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<Color> colors;
  late Timer _timer;
  int currentIndex = 0;
  final _formfiled = GlobalKey<FormState>();
  bool passToggle = false;


  void _saveCityData() async {
    int id=int.parse(_idcontroller.text.trim());
    String cityName = _cityNameController.text.trim();
    double latitude = double.parse(_latitudeController.text.trim());
    double longitude = double.parse(_longitudeController.text.trim());
    String email = _emailController.text.trim();

      await FirebaseFirestore.instance.collection('cities').doc(cityName).set({
        'Id':id,
        'city': cityName,
        'latitude': latitude,
        'longitude': longitude,
        'email': email,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('City data saved successfully!')),
      );
      _idcontroller.clear();
      _cityNameController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
      _emailController.clear();
    }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Save"),
          content: Text("Are you sure you want to save city data?"),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
              ),
              child: Text("Cancel",style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green
              ),
              child: Text("Save",style: TextStyle(color: Colors.black,),),
              onPressed: () {
                Navigator.of(context).pop();
                _saveCityData();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    colors = [
      hexStringToColor("#caf0f8"),
      hexStringToColor("#0077b6"),
      hexStringToColor("#00b4d8"),
      hexStringToColor("#caf0f8"),
    ];
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % colors.length;
      });
    });
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Enter City Data"),
        backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
      ),
      body: AnimatedContainer(
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
        child: Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Card(
                    color:Color.fromARGB(255, 21, 30, 100).withOpacity(0.5),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formfiled,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/location.gif",
                              width: 150,
                              height: 130,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: _idcontroller,
                              style: TextStyle(color: Colors.white.withOpacity(0.9)),
                              obscureText: passToggle,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.perm_identity,
                                  color: Colors.white70,
                                ),
                                labelText: "ID",
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                filled: true,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                fillColor: Colors.white.withOpacity(0.3),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                    const BorderSide(width: 0, style: BorderStyle.none)),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "enter ID";
                                }
                                bool namevalid = RegExp('[0-9]').hasMatch(value);
                                if (!namevalid) {
                                  return "enter valid ID ";
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: _cityNameController,
                              style: TextStyle(color: Colors.white.withOpacity(0.9)),
                              obscureText: passToggle,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.location_city,
                                  color: Colors.white70,
                                ),
                                labelText: " City Name",
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                filled: true,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                fillColor: Colors.white.withOpacity(0.3),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                        const BorderSide(width: 0, style: BorderStyle.none)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "enter City Name";
                                }
                                bool namevalid = RegExp('[a-z]').hasMatch(value);
                                if (!namevalid) {
                                  return "enter valid City Name ";
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: _latitudeController,
                              style: TextStyle(color: Colors.white.withOpacity(0.9)),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                ),
                                labelText: " Latitude",
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                filled: true,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                fillColor: Colors.white.withOpacity(0.3),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                        const BorderSide(width: 0, style: BorderStyle.none)),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "enter Latitude";
                                }
                                bool Latitudevalid = RegExp('[0-9]').hasMatch(val);
                                if (!Latitudevalid) {
                                  return "enter valid Latitude ";
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: _longitudeController,
                              style: TextStyle(color: Colors.white.withOpacity(0.9)),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                ),
                                labelText: " Longitude",
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                filled: true,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                fillColor: Colors.white.withOpacity(0.3),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                        const BorderSide(width: 0, style: BorderStyle.none)),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "enter Longitude";
                                }
                                bool Longitudevalid = RegExp('[0-9]').hasMatch(value);
                                if (!Longitudevalid) {
                                  return "enter valid Longitude ";
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: _emailController,
                              style: TextStyle(color: Colors.white.withOpacity(0.9)),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white70,
                                ),
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                                filled: true,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                fillColor: Colors.white.withOpacity(0.3),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide:
                                        const BorderSide(width: 0, style: BorderStyle.none)),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "enter email";
                                }
                                bool emailvalid =
                                    RegExp('[a-z0-9]+@[a-z]+\.[a-z]{2,3}').hasMatch(value);
                                if (!emailvalid) {
                                  return "enter valid email";
                                }
                              },
                            ),
                            SizedBox(height: 20),

                            firebaseUIButton(
                                context, "Save City", () {
                              if (_formfiled.currentState!.validate())
                                onTap:_showConfirmDialog(context);
                            }),
                            Container(
                              padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
