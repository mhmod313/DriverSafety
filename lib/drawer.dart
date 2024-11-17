
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectf/profile.dart';
import 'package:projectf/rating.dart';
import 'package:projectf/sign_in.dart';
import 'package:projectf/homepage.dart';
import 'package:projectf/utlis/utils.dart';
import 'about.dart';
import 'core/Fadeanimation.dart';

class MyDrawer extends StatefulWidget {
  final double width;

  const MyDrawer({Key? key, required this.width,}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.5, 2, 0.8, 2.8],
          colors: [
            hexStringToColor("#caf0f8"),
            hexStringToColor("#0077b6"),
            hexStringToColor("#00b4d8"),
            hexStringToColor("#caf0f8"),
          ],
        ),
      ),
      child: SafeArea(
        child: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: SizedBox(
            width: widget.width,
            height: double.infinity,
            child: FadeAnimation(
              delay: 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    child: Image.asset("assets/output-onlinegiftools.gif"),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.home,color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),),
                      title: Text('HomePage'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => home()),
                        );
                      },
                      trailing:Icon(Icons.send,color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.person,color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),),
                      title: Text('Profile'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => profile()),
                        );
                      },
                      trailing:Icon(Icons.send,color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.insert_emoticon_rounded,color:Color.fromARGB(255, 21, 30, 100).withOpacity(0.7) ,),
                      title: Text('Rating'),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RatingBarScreen()));
                      },
                      trailing:Icon(Icons.send,color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.info,color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),),
                      title: Text('About'),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>About()));
                      },
                      trailing:Icon(Icons.send,color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),),
                    ),
                  ),
                  SizedBox(height:300),
                  Container(
                    width:double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        bottom:BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        left:  BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        right:BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.5, 0.8, 0.5, 0.2],
                        colors: [
                          hexStringToColor("#caf0f8"),
                          hexStringToColor("#0077b6"),
                          hexStringToColor("#00b4d8"),
                          hexStringToColor("#caf0f8"),
                        ],
                      ),
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Logout",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black
                        ),),
                        IconButton(
                          color: Colors.white,
                          iconSize: 40,
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              print("Signed Out");
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => SignInScreen()));
                            });
                          }, icon: Icon(Icons.logout_rounded,color: Colors.black,),
                        ),
                      ],

                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}