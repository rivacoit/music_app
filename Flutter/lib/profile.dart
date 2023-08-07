// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app/components/buttons.dart';
import 'package:music_app/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(profilePicLink),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    user.displayName!,
                    style: TextStyle(
                      color: Color(0xFf232946),
                      fontFamily: "Poppins",
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user.email!,
                    style: TextStyle(
                      color: Color(0xFf232946),
                      fontFamily: "Poppins",
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFf232946),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Account",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xfffffffe),
                            ),
                          ),
                        ),
                        Divider(
                          height: 20,
                          thickness: 3,
                          color: Color(0xfffffffe),
                        ),
                        SettingsButton(
                          text: "Change Profile Picture",
                          func: _profilepicture,
                        ),
                        SettingsButton(
                          text: "Change Name",
                          func: () {
                            user.updateDisplayName("hi");
                          },
                        ),
                        SettingsButton(
                          text: "Change Email",
                          func: () {
                            user.updateDisplayName("hi");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
