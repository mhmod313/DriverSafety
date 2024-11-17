import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectf/profile.dart';
import 'package:projectf/sign_in.dart';
import 'package:projectf/splashscreen.dart';
import 'package:projectf/homepage.dart';
import 'about.dart';
import 'addcity.dart';
import 'detiction.dart';
import 'edit_profile.dart';
import 'homepage_admin.dart';
import 'sign_up.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic notifications",
        channelDescription: "offer",
      )
    ],
    debug: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var islogin = false;

  checkislogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          islogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkislogin();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
      if(!isAllowed)
      {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drever Safety',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:islogin != null
        ? (islogin ?splashscreen() : SignInScreen())
        : SignInScreen());
  }
}
