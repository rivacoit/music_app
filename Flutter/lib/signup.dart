// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:music_app/components/textfield.dart";
import 'package:music_app/components/buttons.dart';
import 'package:music_app/login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class ErrorMessage extends StatelessWidget {
  final String header;
  final String bodyText;
  const ErrorMessage({
    super.key,
    required this.header,
    required this.bodyText,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        header,
        style: TextStyle(
          fontFamily: "Poppins",
          color: Color(0xff232946),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Color(0xfffffffe),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: Text(
        bodyText,
        style: TextStyle(
          fontFamily: "Poppins",
          color: Color(0xff232946),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(
              Color(0xFF232946),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
          child: Text(
            "OK",
            style: TextStyle(
              color: Color(0xffb8c1ec),
            ),
          ),
        ),
      ],
    );
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmcontroller = TextEditingController();
  void _signup() async {
    final String email = _emailcontroller.text.trim();
    final String password = _passwordcontroller.text.trim();
    final String confirm = _confirmcontroller.text.trim();
    if (password != confirm) {
      showDialog(
          context: context,
          builder: (context) => ErrorMessage(
                header: "Signup Error",
                bodyText: "Passwords do not match.",
              ));
      return;
    }
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("successful");
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => ErrorMessage(
                header: "Signup Error",
                bodyText: e.toString(),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Hello.",
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
              height: 15,
            ),
            MyTextField(
              controller: _confirmcontroller,
              hintText: "Confirm password",
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            ButtonTwo(
              text: "Sign up",
              func: _signup,
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
