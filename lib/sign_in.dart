import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectf/detiction.dart';
import 'package:projectf/homepage.dart';
import 'package:projectf/homepage_admin.dart';
import 'package:projectf/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:rebuilt/screens/home_screen_contractor.dart';
//import 'package:rebuilt/screens/home_screen_eng.dart';
import 'addcity.dart';
import 'reset_passowrd.dart';
import 'sign_up.dart';
import 'reusable_widget/reusable_widget.dart';
import 'core/Fadeanimation.dart';
import 'utlis/utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool passToggle = true;
  String collectionName = "users";
  final _formkey = GlobalKey<FormState>();
  final _formf = GlobalKey<FormState>();
  List<String> emailList = [];

  late List<Color> colors;
  late Timer _timer;
  int currentIndex = 0;


  void uu() {
    var firstore = FirebaseFirestore.instance
        .collection(collectionName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (data!.containsKey('email')) {
            String email = data['email'];
            emailList.add(email);
          }
        });
      } else {
        print('Collection "$collectionName" does not exist or is empty');
      }
    });
  }

  @override
  void initState() {
    uu();
    // TODO: implement initState
    super.initState();

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
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Form(
                key: _formf,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 5,
                    color: const Color.fromARGB(255, 171, 178, 250).withOpacity(
                        0.4),
                      child: Container(
                        width: 400,
                        padding: const EdgeInsets.all(40.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FadeAnimation(
                              delay: 0.8,
                              child: Image.asset(
                                "assets/output-onlinegiftools.gif",
                                width: 100,
                                height: 100,
                              ),
                            ),
                            SizedBox(height: 15,),
                            FadeAnimation(
                              delay: 1,
                              child: const Text(
                                "Please sign in to continue",
                                style: TextStyle(
                                    color: Colors.white, letterSpacing: 0.5),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FadeAnimation(
                              delay: 1,
                              child: TextFormField(
                                cursorColor: Colors.white,
                                controller: _emailTextController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.9)),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.alternate_email_outlined,
                                    color: Colors.white70,
                                  ),
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.9)),
                                  filled: true,
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  fillColor: Colors.white.withOpacity(0.3),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "enter email";
                                  }
                                  bool emailvalid =
                                  RegExp('[a-z0-9]+@[a-z]+\.[a-z]{2,3}')
                                      .hasMatch(value);
                                  if (!emailvalid) {
                                    return "enter valid email";
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                                delay: 1,
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  controller: _passwordTextController,
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: passToggle,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9)),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.white70,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          passToggle = !passToggle;
                                        });
                                      },
                                      child: Icon(
                                          color: Colors.black54,
                                          passToggle
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                    ),
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    filled: true,
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                    fillColor: Colors.white.withOpacity(0.3),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30.0),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "please enter passowrd";
                                    } else if (_passwordTextController
                                        .text.length <
                                        6) {
                                      return "passowrd length not be less than 6 character";
                                    }
                                  },
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            FadeAnimation(
                              delay: 1,
                              child: forgetPassword(context),
                            ),
                            FadeAnimation(
                              delay: 0.8,
                              child: firebaseUIButton(context, "Sign In", () async {
                                SharedPreferences _pre= await SharedPreferences.getInstance();
                                _pre.setString("e",_emailTextController.text.trim());
                                _pre.setString("p",_passwordTextController.text.trim());
                                if (_formf.currentState!.validate()) {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                      email:
                                      _emailTextController.text.trim(),
                                      password: _passwordTextController.text
                                          .trim())
                                      .then((value) {
                                    if (emailList.isNotEmpty) {
                                      emailList.forEach((email) {
                                        print(email);
                                        if (email == _emailTextController.text.trim()) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      splashscreen()));
                                        }
                                        else if(_emailTextController.text.trim()=='driversavety_admin@gmail.com' && _passwordTextController.text.trim()=='admin12345')
                                          {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    splashscreen()));
                                          }
                                      });
                                    }
                                  }).onError((error, stackTrace) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(error.toString())));
                                  });
                                }
                              }),
                            ),
                            FadeAnimation(delay: 0.8, child: signUpOption())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
