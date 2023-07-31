// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/home_page.dart';
import 'package:music_app/nlp_page.dart';
import 'package:music_app/search.dart';
import 'package:music_app/signup.dart';
import "package:music_app/components/textfield.dart";
import 'package:music_app/components/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  void _signup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage(),
      ),
    );
  }

  void _login() async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: _emailcontroller.text,
        password: _passwordcontroller.text,
      );
      print("login successful");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(),
        ),
      );
    } catch (e) {
      print("login failed $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0xFF232946),
          ),
          leading: BackButton(),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          color: Color(0xFFd4d8f0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome back.",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  wordSpacing: 5,
                  color: Color(0xFF232946),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              MyTextField(
                controller: _emailcontroller,
                hintText: "Email",
                obscureText: false,
              ),
              SizedBox(
                height: 15,
              ),
              MyTextField(
                controller: _passwordcontroller,
                hintText: "Password",
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              ButtonTwo(
                text: "Login",
                func: _login,
              ),
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: _signup,
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                      Colors.transparent,
                    ),
                  ),
                  child: Text(
                    "Don't have an account? Sign up!",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Color(0xFF232946),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
