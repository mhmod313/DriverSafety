import 'package:firebase_auth/firebase_auth.dart';
import 'core/Fadeanimation.dart';
import 'reusable_widget/reusable_widget.dart';
import 'sign_in.dart';
import 'utlis/utils.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  final _form=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
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
                              color: Colors.white,
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: Colors.white.withOpacity(0.9)),
                            filled: true,
                            floatingLabelBehavior:
                            FloatingLabelBehavior.never,
                            fillColor: Colors.black.withOpacity(0.5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none)),
                          ),
                          validator: (value){
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
                      FadeAnimation(delay: 1, child:firebaseUIButton(context, "Reset Password", () {
                        if(_form.currentState!.validate()){
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(email: _emailTextController.text)
                              .then((value) => Navigator.of(context).pop());
                        }
                      }) )
                    ],
                  ),
                ),
              ))),
    );
  }
}