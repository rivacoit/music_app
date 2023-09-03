// ignore_for_file: prefer_const_constructors, must_be_immutable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/profile.dart';
import 'package:page_transition/page_transition.dart';

import 'components/textfield.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});
  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  void _savepassword() async {
    if (_emailcontroller.text.trim() == user.email!) {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailcontroller.text.trim());
    }
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.leftToRight,
        child: ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 30.0),
              child: GestureDetector(
                onTap: _savepassword,
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                  ),
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Confirm your email",
                  style: TextStyle(
                    color: Color(0xFf232946),
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "A password reset email will be sent if the email you entered matches the email on file.",
                  style: TextStyle(
                    color: Color(0xFf232946),
                    fontFamily: "Poppins",
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                MyTextField(
                  controller: _emailcontroller,
                  hintText: "Enter your email",
                  obscureText: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
