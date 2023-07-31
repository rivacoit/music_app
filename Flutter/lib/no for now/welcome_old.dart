// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import "package:music_app/components/textfield.dart";
import 'package:music_app/components/buttons.dart';
import "package:music_app/home_page.dart";
import 'package:music_app/login.dart';
import "package:music_app/signup.dart";

class OldWelcomePage extends StatefulWidget {
  const OldWelcomePage({super.key});

  @override
  State<OldWelcomePage> createState() => _OldWelcomePageState();
}

class _OldWelcomePageState extends State<OldWelcomePage> {
  void _loginred() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void _signupred() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage(),
      ),
    );
  }

  void guestred() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/welcome_3.jpeg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ],
              )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Welcome.",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    fontSize: 50,
                  ),
                ),
                Text(
                  "We are glad you are here.",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ButtonTwo(
                  text: "Login",
                  func: _loginred,
                ),
                SizedBox(
                  height: 14,
                ),
                ButtonTwo(
                  text: "Signup",
                  func: _signupred,
                ),
                TextButton(
                  onPressed: guestred,
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                      Colors.transparent,
                    ),
                  ),
                  child: Text(
                    "Just looking around? Continue as guest.",
                    style: TextStyle(
                      fontFamily: "Nunito",
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
