// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_app/components/buttons.dart';
import 'package:music_app/home_page.dart';
import 'package:music_app/update_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = FirebaseAuth.instance.currentUser!;
  String profilePicLink = "";
  String user_name = "";
  String email = "";
  @override
  void initState() {
    user_name = user.displayName!;
    email = user.email!;
    profilePicLink = user.photoURL!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
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
                  user_name,
                  style: TextStyle(
                    color: Color(0xFf232946),
                    fontFamily: "Poppins",
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Color(0xFf232946),
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 10,
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
                        text: "Update profile",
                        func: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProfilePage(),
                            ),
                          );
                        },
                        icon: Icons.edit,
                      ),
                      SettingsButton(
                        text: "Search history",
                        func: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        icon: Icons.search,
                      ),
                      SettingsButton(
                        text: "Playlists archive",
                        func: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        icon: Icons.archive,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
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
                          "Privacy and Security",
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
                        text: "Change password",
                        func: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProfilePage(),
                            ),
                          );
                        },
                        icon: Icons.lock,
                      ),
                      SettingsButton(
                        text: "Email notifications settings",
                        func: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        icon: Icons.email,
                      ),
                      SettingsButton(
                        text: "Push notifications settings",
                        func: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        icon: Icons.notification_important,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
