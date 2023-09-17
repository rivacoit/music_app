// ignore_for_file: camel_case_types, use_build_context_synchronously, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_app/signup.dart';

import 'components/textfield.dart';
import 'home_page.dart';

class linkWithEmail extends StatefulWidget {
  const linkWithEmail({super.key});

  @override
  State<linkWithEmail> createState() => _linkWithEmailState();
}

class _linkWithEmailState extends State<linkWithEmail> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  void _merge() async {
    if (_passwordcontroller.text.trim() ==
        _confirmpasswordcontroller.text.trim()) {
      final credential = EmailAuthProvider.credential(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim());
      try {
        final userCredential = await FirebaseAuth.instance.currentUser
            ?.linkWithCredential(credential);
        await showDialog(
          context: context,
          builder: (context) => ErrorMessage(
            header: "Merge success.",
            bodyText:
                "Your guest account has been successfully merged with your Google account. You will now be directed to the home page.",
          ),
        );
        User user = FirebaseAuth.instance.currentUser!;
        user.updateDisplayName(_namecontroller.text.trim());
        user.updatePhotoURL(
            "https://marvel-b1-cdn.bc0a.com/f00000000151180/sou.edu/academics/wp-content/uploads/sites/14/2016/07/placeholder-3.png");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "provider-already-linked":
            print("The provider has already been linked to the user.");
            break;
          case "invalid-credential":
            print("The provider's credential is not valid.");
            break;
          case "credential-already-in-use":
            print("The account corresponding to the credential already exists, "
                "or is already linked to a Firebase User.");
            break;
          // See the API reference for the full list of error codes.
          default:
            print("Unknown error.");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: GestureDetector(
              onTap: _merge,
              child: Text(
                "Merge Accounts",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                ),
              ),
            ),
          ),
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
                  "Email",
                  style: TextStyle(
                    color: Color(0xFf232946),
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: _emailcontroller,
                  hintText: "",
                  obscureText: false,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Name",
                  style: TextStyle(
                    color: Color(0xFf232946),
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: _namecontroller,
                  hintText: "",
                  obscureText: false,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Password",
                  style: TextStyle(
                    color: Color(0xFf232946),
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: _passwordcontroller,
                  hintText: "",
                  obscureText: true,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Confirm password",
                  style: TextStyle(
                    color: Color(0xFf232946),
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: _confirmpasswordcontroller,
                  hintText: "",
                  obscureText: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
