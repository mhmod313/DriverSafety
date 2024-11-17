import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectf/utlis/utils.dart';

import 'core/Fadeanimation.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}


class _AboutState extends State<About> {
  late List<Color> colors;
  late Timer _timer;
  int currentIndex = 0;
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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('About'),
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
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.only(top: 80,bottom: 80,left: 30,right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeAnimation(
                  delay: 0.8,
                  child: Text(
                    "Driver-Safety Application ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Color.fromARGB(
                        255, 0, 0, 0)),
                  ),
                ),
                FadeAnimation(delay: 0.8, child: Text("1.0.0",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Color.fromARGB(
                    255, 0, 0, 0)),)),
                FadeAnimation(
                  delay: 1.3,
                  child: Image.asset(
                    "assets/output-onlinegiftools.gif",
                    width: 100,
                    height: 100,
                  ),
                ),
                FadeAnimation(delay: 1.8, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.copyright),
                    Text("2022-2023 Driver-Safety"),
                  ],
                ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
