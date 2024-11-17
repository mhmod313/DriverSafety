import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectf/drawer.dart';
import 'package:projectf/utlis/utils.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _numbercarController = TextEditingController();
  final _typecarController = TextEditingController();

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
  _userDataSubscription;

  @override
  void initState() {
    super.initState();
    // Retrieve user data and populate the text fields
    fetchUserData();
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _numbercarController.dispose();
    _typecarController.dispose();

    super.dispose();
  }

  void fetchUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userDataSubscription = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.size > 0) {
          Map<String, dynamic> userData = snapshot.docs[0].data();
          setState(() {
            _firstnameController.text = userData['firstname'] ?? '';
            _lastnameController.text = userData['lastname'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _phoneController.text = userData['phone'] ?? '';
             _numbercarController.text = userData['numbercar'] ?? '';
             _typecarController.text = userData['typecar'] ?? '';
          });
        }
      });
    }
  }

  // void updateEmail(String newEmail) async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user != null) {
  //     // Re-authenticate the user to confirm their identity
  //     AuthCredential credential = EmailAuthProvider.credential(
  //       email:_emailController.text,
  //       password: 'current_password', // Provide the user's current password here
  //     );
  //
  //     try {
  //       await user.reauthenticateWithCredential(credential);
  //
  //       // Update the user's email address
  //       await user.updateEmail(_emailController.text);
  //
  //       // Display a success message to the user
  //       print('Email address updated successfully.');
  //     } catch (e) {
  //       // Handle any errors that occur during re-authentication or email update
  //       print('Error updating email: $e');
  //     }
  //   }
  // }

  void _showupdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update delete"),
          content: Text("Are you sure you want to Update city data?"),
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
              child: Text("Update",style: TextStyle(color: Colors.black,),),
              onPressed: () {
                Navigator.of(context).pop();
                updatedata();
              },
            ),
          ],
        );
      },
    );
  }
  void updatedata() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user!.email)
          .get();
      if (user != null) {
        try {
          await user.updateEmail(_emailController.text.trim());
          print('Email address updated successfully.');
        } catch (e) {
          print('Error updating email: $e');
        }
      }

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        final DocumentReference profileRef = documentSnapshot.reference;

        await profileRef.update({
          'firstname': _firstnameController.text,
          'lastname': _lastnameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'typecar':_typecarController.text,
          'numbercar':_numbercarController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${e}')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
          title: Text('Edit Profile')
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.5, 1.0, 0.5],
            colors: [
              hexStringToColor("#caf0f8"),
              hexStringToColor("#0077b6"),
              hexStringToColor("#caf0f8"),
              hexStringToColor("#00b4d8"),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 3,
                    color: const Color.fromARGB(255, 250, 199, 171)
                        .withOpacity(0),
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _firstnameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                              ),
                              labelText: "firstname",
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide:
                                  const BorderSide(width: 0, style: BorderStyle.none)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your firstname';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            controller: _lastnameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                              ),
                              labelText: "lastname",
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide:
                                  const BorderSide(width: 0, style: BorderStyle.none)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your lastname';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.alternate_email,
                                color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                              ),
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide:
                                  const BorderSide(width: 0, style: BorderStyle.none)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone,
                                color:  Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                              ),
                              labelText: "phone",
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide:
                                  const BorderSide(width: 0, style: BorderStyle.none)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            controller: _numbercarController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.car_crash_sharp,
                                color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                              ),
                              labelText: "number_car",
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide:
                                  const BorderSide(width: 0, style: BorderStyle.none)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your number car';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            controller: _typecarController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.car_repair_sharp,
                                color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                              ),
                              labelText: "type_car",
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide:
                                  const BorderSide(width: 0, style: BorderStyle.none)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your type_car';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                            ),
                            onPressed:()=> _showupdateDialog(context),
                            child: Text('Update Profile'),
                          ),
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
      drawer: MyDrawer(
        width: 300,
      ),
    );
  }
}
