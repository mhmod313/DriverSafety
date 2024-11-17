import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectf/utlis/utils.dart';

import 'core/Fadeanimation.dart';
import 'drawer.dart';
import 'edit_profile.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  User? currentuser = FirebaseAuth.instance.currentUser;
  String collectionName = "users";
  String collectionName1 = "engineering";
  String collectionName2 = "contractor";
  var s;
  List<String> emailList = [];

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
            setState(() {
              if (data['email'] == currentuser!.email) emailList.add(email);
            });
            print('Collection "$emailList" does not exist or is empty');
          }
        });
      } else {
        print('Collection "$emailList" does not exist or is empty');
      }
    });
  }

  @override
  void initState() {
    uu();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('profile'),
        backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
      ),
      body: Container(
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
        child: FadeAnimation(
          delay: 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person,size: 80,),
              SizedBox(
                height: 40,
              ),
              if (emailList.isNotEmpty)
                Container(
                  height: 300,
                  child: Card(
                    elevation: 5,
                    color: const Color.fromARGB(255, 171, 178, 250)
                        .withOpacity(0.4),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .where('email', isEqualTo: currentuser!.email)
                                .snapshots(),
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                  color: Colors.white,
                                );
                              }
                              final data = snapshot.data?.docs;
                              return Container(
                                alignment: Alignment.center,
                                height: 35,
                                child: ListView.builder(
                                    itemCount: data?.length,
                                    itemBuilder: (ctx, index) => Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Name: ${data![index]['firstname']} ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 25),
                                              ),
                                              Text(
                                                "${data[index]['lastname']}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 25),
                                              ),
                                            ],
                                          ),
                                        )),
                              );
                            }),
                          ),
                        ),
                        const Divider(
                          endIndent: 20,
                          indent: 20,
                          thickness: 1,
                          color: Color.fromARGB(255, 117, 198, 255),
                        ),
                        Card(
                          color: Color.fromARGB(255, 105, 230, 246),
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: ListTile(
                            leading: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            title: Container(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .where('email',
                                        isEqualTo: currentuser!.email)
                                    .snapshots(),
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(
                                      color: Colors.white,
                                    );
                                  }
                                  final data = snapshot.data?.docs;
                                  return Container(
                                    alignment: Alignment.center,
                                    height: 15,
                                    child: ListView.builder(
                                        itemCount: data?.length,
                                        itemBuilder: (ctx, index) => Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "+963:${data![index]['phone']}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          "SourceSansPro",
                                                      letterSpacing: 3,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        Card(
                            color: Color.fromARGB(255, 105, 230, 246),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: ListTile(
                              leading: Icon(
                                Icons.alternate_email,
                                color: Colors.white,
                              ),
                              title: Container(
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .where('email',
                                          isEqualTo: currentuser!.email)
                                      .snapshots(),
                                  builder: ((context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(
                                        color: Colors.white,
                                      );
                                    }
                                    final data = snapshot.data?.docs;
                                    return Container(
                                      alignment: Alignment.center,
                                      height: 20,
                                      child: ListView.builder(
                                          itemCount: data?.length,
                                          itemBuilder: (ctx, index) =>
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${data![index]['email']}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "SourceSansPro",
                                                        letterSpacing: 3,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                    );
                                  }),
                                ),
                              ),
                            )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                          ),
                          onPressed:(){Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => EditProfileScreen()));},
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
      drawer: MyDrawer(
        width: 300,
      ),
    );
  }
}
