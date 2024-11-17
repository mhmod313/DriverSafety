import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:projectf/about.dart';
import 'package:projectf/detiction.dart';
import 'package:projectf/utlis/utils.dart';
import 'package:http/http.dart' as http;

import 'drawer.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late List<Color> colors;
  late Timer _timer;
  int currentIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late Timer _timer1;

  final List<Map<String, String>> _imagesWithCaptions = [
    {
      'image': 'assets/truck safty.webp', // Replace with your image paths
      'caption': 'ًWelcome To Driver Safty',
    },
    {
      'image': 'assets/sleep.webp',
      'caption': 'Monitoring the drivers eye movement using artificial intelligence techniques\n and treating sleep and snoozing states',
    },
    {
      'image': 'assets/location.jpg',
      'caption': 'Enhance the application by obtaining the nearest security center to the driver \nand sending an email message that includes the driver’s location and name',
    },
  ];

  ButtonState _buttonState = ButtonState.idle;


  void _onPressed() async {
    setState(() {
      _buttonState = ButtonState.loading;
    });

    try {
      // Perform your async operation here (e.g., sending an email)
      // For demonstration, let's just wait for 2 seconds
      await Future.delayed(Duration(seconds: 2));

      // If the operation is successful
      setState(() {
        _buttonState = ButtonState.success;
      });

      // Navigate to the next screen after a short delay to show the success state
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ImageUploader()));
      });
    } catch (e) {
      // If the operation fails
      setState(() {
        _buttonState = ButtonState.fail;
      });

      // Optionally, you could reset the button to idle state after a short delay
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _buttonState = ButtonState.idle;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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

    _timer1 = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _imagesWithCaptions.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController!.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("home page"),
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
        child: Column(
            children: [
              SizedBox(height: 150,),
             Container(
               margin:const EdgeInsets.all(20.0),
               height: 325,
               child: Card(
                   elevation: 5,
                   color: const Color.fromARGB(255, 171, 178, 250).withOpacity(0.4),
                 child: SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _imagesWithCaptions.length,
                      itemBuilder: (context, index) {
                        return Column(
                            children: [
                              SizedBox(height: 30,),
                              Image.asset(
                                _imagesWithCaptions[index]['image']!,
                                fit: BoxFit.cover,
                                height: 140,
                              ),
                              Container(
                                margin:const EdgeInsets.all(20.0),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                                ),

                                child: Text(
                                  _imagesWithCaptions[index]['caption']!,

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                      },
                    ),
                  ),
               ),
             ),
              Container(
                margin: EdgeInsets.fromLTRB(90, 30, 90, 30),
                child:ProgressButton.icon(
                    iconedButtons: {
                      ButtonState.idle: IconedButton(
                          text: "Start",
                          icon: Icon(Icons.play_circle, color: Colors.white),
                          color: Colors.blue.shade300),
                      ButtonState.loading: IconedButton(
                          text: "Loading", color: Colors.deepPurple.shade700),
                      ButtonState.fail: IconedButton(
                          text: "Failed",
                          icon: Icon(Icons.cancel, color: Colors.white),
                          color: Colors.red.shade300),
                      ButtonState.success: IconedButton(
                          text: "Success",
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          color: Colors.green.shade400)
                    },
                    onPressed: _onPressed,
                    state: _buttonState,
                  ),
              ),
            ],
          ),
        ),
      drawer: MyDrawer(width: 300,),
    );
  }
}
