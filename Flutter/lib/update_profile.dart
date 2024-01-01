// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app/components/textfield.dart';
import 'package:music_app/profile.dart';
import 'package:page_transition/page_transition.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  String profilePicLink = "";
  @override
  void initState() {
    profilePicLink = user.photoURL!;
    super.initState();
  }

  void _profilepicture() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref =
        FirebaseStorage.instance.ref().child("profiles/${user.uid}");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        user.updatePhotoURL(value);
        profilePicLink = value;
      });
    });
  }

  void _saveprofile() async {
    String uid = user.uid;

    if (_namecontroller.text.trim() != "") {
      await user.updateDisplayName(_namecontroller.text.trim());

      await FirebaseFirestore.instance
          .collection('userInfo')
          .doc(uid)
          .update({'Name': _namecontroller.text.trim()});
    }
    if (_emailcontroller.text.trim() != "") {
      await user.updateEmail(_emailcontroller.text.trim());

      await FirebaseFirestore.instance
          .collection('userInfo')
          .doc(uid)
          .update({'Email': _emailcontroller.text.trim()});
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
                onTap: _saveprofile,
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
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(profilePicLink),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 200,
                      child: IconButton(
                        onPressed: _profilepicture,
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 30,
                        ),
                      ),
                    )
                  ],
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
                  hintText: user.displayName!,
                  obscureText: false,
                ),
                SizedBox(
                  height: 30,
                ),
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
                  hintText: user.email!,
                  obscureText: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
