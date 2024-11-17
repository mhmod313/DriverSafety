import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectf/detiction.dart';
import 'core/Fadeanimation.dart';
import 'reusable_widget/reusable_widget.dart';
import 'utlis/utils.dart';
import 'package:flutter/src/material/dropdown.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _FirstNameTextController = TextEditingController();
  TextEditingController _LastNameTextController = TextEditingController();
  TextEditingController _PhoneTextController = TextEditingController();
  TextEditingController _typecar = TextEditingController();
  TextEditingController _numbercar = TextEditingController();
  TextEditingController _confirmpasswordTextController = TextEditingController();
  bool passToggle = false;
  final _formfiled = GlobalKey<FormState>();
  String _selected = "user";
  var _image;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 1,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 1.3,
              stops: const [0.3, 1.5, 0.9, 1.8],
              colors: [
                hexStringToColor("#caf0f8"),
                hexStringToColor("#0077b6"),
                hexStringToColor("#00b4d8"),
                hexStringToColor("#caf0f8"),

              ],
            ),
          ),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 5,
                      color:
                      const Color.fromARGB(255, 171, 178, 250).withOpacity(
                          0.4),
                      child: Container(
                        width: 400,
                        padding: const EdgeInsets.all(40.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Form(
                          key: _formfiled,
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              FadeAnimation(
                                delay: 1,
                                child: TextFormField(
                                    cursorColor: Colors.white,
                                    controller: _FirstNameTextController,
                                    keyboardType: TextInputType.name,
                                    obscureText: passToggle,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.white70,
                                      ),
                                      labelText: "First Name",
                                      labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(
                                              0.9)),
                                      filled: true,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      fillColor: Colors.white.withOpacity(
                                          0.3),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please enter First Name";
                                      }
                                    }),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                delay: 1,
                                child: TextFormField(
                                    cursorColor: Colors.white,
                                    controller: _LastNameTextController,
                                    keyboardType: TextInputType.name,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.white70,
                                      ),
                                      labelText: "Last Name",
                                      labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(
                                              0.9)),
                                      filled: true,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      fillColor: Colors.white.withOpacity(
                                          0.3),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please enter Last Name";
                                      }
                                    }),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                delay: 1,
                                child: TextFormField(
                                  cursorColor: Colors.white,
                                  controller: _PhoneTextController,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9)),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.white70,
                                    ),
                                    labelText: "phone number",
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    filled: true,
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                    fillColor: Colors.white.withOpacity(0.3),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            30.0),
                                        borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "please enter phone";
                                    } else
                                    if (_PhoneTextController.text.length !=
                                        10) {
                                      return "you phone number not correct";
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
                                          color: Colors.white.withOpacity(
                                              0.9)),
                                      filled: true,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      fillColor: Colors.white.withOpacity(
                                          0.3),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
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
                                    }),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                delay: 1,
                                child: TextFormField(
                                    cursorColor: Colors.white,
                                    controller: _typecar,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.alternate_email_outlined,
                                        color: Colors.white70,
                                      ),
                                      labelText: "type car",
                                      labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(
                                              0.9)),
                                      filled: true,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      fillColor: Colors.white.withOpacity(
                                          0.3),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "enter type car";
                                      }
                                    }),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                delay: 1,
                                child: TextFormField(
                                    cursorColor: Colors.white,
                                    controller: _numbercar,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.alternate_email_outlined,
                                        color: Colors.white70,
                                      ),
                                      labelText: "number car",
                                      labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(
                                              0.9)),
                                      filled: true,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      fillColor: Colors.white.withOpacity(
                                          0.3),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "enter number car";
                                      }
                                    }),
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
                                        child: Icon(passToggle
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                      labelText: "Password",
                                      labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(
                                              0.9)),
                                      filled: true,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      fillColor: Colors.white.withOpacity(
                                          0.3),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
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
                                height: 20,
                              ),
                              FadeAnimation(
                                  delay: 1,
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    controller: _confirmpasswordTextController,
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
                                        child: Icon(passToggle
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                      labelText: "confirm Password",
                                      labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(
                                              0.9)),
                                      filled: true,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      fillColor: Colors.white.withOpacity(
                                          0.3),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              30.0),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please enter password ";
                                      } else if (_passwordTextController
                                          .text.length <
                                          8) {
                                        return "passowrd length not be less than 8 character";
                                      }else if(_confirmpasswordTextController.text!=_passwordTextController.text){
                                        return "password is not matched";
                                      }
                                    },
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                  delay: 1,
                                  child: firebaseUIButton(
                                      context, "Sign Up", () {
                                    if (_formfiled.currentState!.validate()) {
                                      FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                          email: _emailTextController.text,
                                          password:
                                          _passwordTextController.text)
                                          .then((value) {
                                        print("Created New Account");
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageUploader()));
                                      }).onError((error, stackTrace) {
                                        print("Error ${error.toString()}");
                                      });
                                      adduserdetails(
                                        _typecar.text.trim(),
                                        _FirstNameTextController.text
                                            .trim(),
                                        _LastNameTextController.text.trim(),

                                        _PhoneTextController.text
                                            .trim(),
                                        _emailTextController.text.trim(),
                                        _numbercar.text.trim(),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('user data saved successfully!')),
                                      );
                                    }
                                  })),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }

  Future adduserdetails(String type, String firstname, String lastname,
      String phone,
      String email,String numbercar) async {
    await FirebaseFirestore.instance.collection('users').add({
      'typecar': type,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'email': email,
      'numbercar':numbercar
    });
  }
}
