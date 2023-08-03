// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app/home_page.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? image;
  void _signupred() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  User user = FirebaseAuth.instance.currentUser!;

  void _selectimage() async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Uint8List img = await file.readAsBytes();
      setState(() {
        image = img;
      });
    }
    _saveprofile();
  }

  void _saveprofile() async {
    String resp = " Some Error Occurred";
    final FirebaseStorage storage = FirebaseStorage.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      Reference ref = storage.ref().child("profilePicture");
      UploadTask uploadTask = ref.putData(image!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      await firestore.collection("userinfo").add({
        'profilepic': downloadUrl,
        'email': user.email,
      });
      resp = "success";
    } catch (e) {
      resp = e.toString();
    }
    print(resp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      image != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(image!),
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                "https://marvel-b1-cdn.bc0a.com/f00000000151180/sou.edu/academics/wp-content/uploads/sites/14/2016/07/placeholder-3.png",
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        left: 80,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFf232946),
                          child: IconButton(
                            onPressed: _selectimage,
                            icon: Icon(
                              Icons.add_a_photo_rounded,
                              size: 20,
                            ),
                            color: Color(0xFfffffff),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName!,
                        style: TextStyle(
                          color: Color(0xFf232946),
                          fontFamily: "Poppins",
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email!,
                        style: TextStyle(
                          color: Color(0xFf232946),
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
