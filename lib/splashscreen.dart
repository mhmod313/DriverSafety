import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:projectf/homepage.dart';
import 'detiction.dart';
import 'homepage_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splashscreen extends StatefulWidget {

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  String email='driversavety_admin@gmail.com';

  String password='admin12345';

  bool isadmin=false;
  User? user = FirebaseAuth.instance.currentUser;

   navigationPage() async {
    SharedPreferences _pre = await SharedPreferences.getInstance();
    var e = _pre.getString("e");
    var p = _pre.getString("p");
    if(email==e){
    return  Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => homeadmin()));
    }else{
    return  Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => home()));
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Image.asset('assets/OpenerLoading.gif'),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.cyan,
                ),
                child: TextButton(
                  child: Text("welcome",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  ),
                  onPressed: navigationPage,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
