// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:music_app/components/textfield.dart";
import 'package:music_app/components/buttons.dart';
import 'package:music_app/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:music_app/components/errorutils.dart';

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
  final TextEditingController _namecontroller = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirm = true;

  void _signup() async {
    final String email = _emailcontroller.text.trim();
    final String password = _passwordcontroller.text.trim();
    final String confirm = _confirmcontroller.text.trim();
    final String name = _namecontroller.text.trim();

    if (password != confirm) {
      showDialog(
        context: context,
        builder: (context) => ErrorMessage(
          header: "Signup Error",
          bodyText: "Passwords do not match.",
        ),
      );
      return;
    }
    try {
      //create user
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = FirebaseAuth.instance.currentUser!;
      user.updateDisplayName(name);

      await FirebaseFirestore.instance
          .collection('userInfo')
          .doc(user.uid)
          .set({
        'Name': name,
        'Email': email,
      });

      user.updatePhotoURL(
        "https://marvel-b1-cdn.bc0a.com/f00000000151180/sou.edu/academics/wp-content/uploads/sites/14/2016/07/placeholder-3.png",
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Sign up successful",
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
            "You have successfully created an account.",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Color(0xff232946),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              ),
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
                "Log in",
                style: TextStyle(
                  color: Color(0xffb8c1ec),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await FirebaseAuth.instance.signOut();
            //     Navigator.pushReplacement(
            //       context,
            //       PageTransition(
            //         type: PageTransitionType.leftToRight,
            //         child: LoginPage(),
            //       ),
            //     );
            //   },
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStatePropertyAll<Color>(
            //       Color(0xFF232946),
            //     ),
            //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //       RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(0),
            //       ),
            //     ),
            //   ),
            //   child: Text(
            //     "Log out",
            //     style: TextStyle(
            //       color: Color(0xffb8c1ec),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LoginPage(),
      //   ),
      // );
    } catch (e) {
      String errorMessage = removeErrorCode(e.toString());
      showDialog(
        context: context,
        builder: (context) => ErrorMessage(
          header: "Signup Error",
          bodyText: errorMessage,
        ),
      );
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
              controller: _namecontroller,
              hintText: "Name",
              obscureText: false,
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              controller: _emailcontroller,
              hintText: "Email",
              obscureText: false,
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                autofocus: false,
                obscureText: obscurePassword,
                controller: _passwordcontroller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xFF232946),
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      }),
                  hintText: "Password",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF232946),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF232946),
                      width: 3,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF232946),
                      width: 3,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                autofocus: false,
                obscureText: obscureConfirm,
                controller: _confirmcontroller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xFF232946),
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirm = !obscureConfirm;
                        });
                      }),
                  hintText: "Confirm password",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF232946),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF232946),
                      width: 3,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF232946),
                      width: 3,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                ),
              ),
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
