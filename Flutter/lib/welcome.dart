// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:music_app/home_page.dart";
import 'package:music_app/login.dart';
import 'package:music_app/lyrics_analysis_page.dart';
import 'package:music_app/search.dart';
import "package:music_app/signup.dart";
import 'package:music_app/components/buttons.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void _loginred() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void _signupred() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage(),
      ),
    );
  }

  void guestred() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LyricsAnalysisPage(),
      ),
    );
  }

  void _signinwithgoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232946),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 22.0,
            vertical: 50.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Welcome.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Color(0xFFfffffe),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  fontSize: 50,
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                "Let's find your next great listen.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Color(0xFFb8c1ec),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ButtonOne(
                text: "Login",
                func: _loginred,
              ),
              SizedBox(
                height: 20,
              ),
              ButtonOne(
                text: "Signup",
                func: _signupred,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "or",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFb8c1ec),
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              LogoButton(
                logo: FaIcon(
                  FontAwesomeIcons.google,
                  color: Color(0xFF232946),
                  size: 25,
                ),
                func: _signinwithgoogle,
              ),
              SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: guestred,
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    Colors.transparent,
                  ),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  "Just looking around? Continue as guest.",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Color(0xFFb8c1ec),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
