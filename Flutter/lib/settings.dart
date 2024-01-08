// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/profile.dart';
import 'package:music_app/update_password.dart';
import 'package:music_app/welcome.dart';
import 'package:page_transition/page_transition.dart';

import 'components/buttons.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xFF232946),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF232946),
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                child: ProfilePage(),
                type: PageTransitionType.leftToRight,
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
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
                      // SettingsButton(
                      //   text: "Update profile",
                      //   func: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => UpdateProfilePage(),
                      //       ),
                      //     );
                      //   },
                      //   icon: Icons.edit,
                      // ),
                      // SettingsButton(
                      //   text: "Search history",
                      //   func: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => SearchHistPage(),
                      //       ),
                      //     );
                      //   },
                      //   icon: Icons.search,
                      // ),
                      // SettingsButton(
                      //   text: "Saved songs",
                      //   func: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => SavedSongs(),
                      //       ),
                      //     );
                      //   },
                      //   icon: Icons.archive,
                      // ),
                      SettingsButton(
                        text: "Log out",
                        func: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Logging out",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Color(0xff232946),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Color(0xfffffffe),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              content: Text(
                                "Are you sure you want to log out?",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Color(0xff232946),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                      Color(0xFF232946),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Color(0xffb8c1ec),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        child: WelcomePage(),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                      Color(0xFF232946),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Log out",
                                    style: TextStyle(
                                      color: Color(0xffb8c1ec),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icons.logout,
                      ),
                      SettingsButton(
                        text: "Delete account",
                        func: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "DELETING ACCOUNT",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              content: Text(
                                "ARE YOU SURE YOU WANT TO DELETE YOUR ACCOUNT? THIS CANNOT BE REVERSED.",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.black,
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                      Color(0xFF232946),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("userInfo")
                                        .doc(user.uid)
                                        .delete()
                                        .then(
                                          (doc) => print("Document deleted"),
                                          onError: (e) => print(
                                              "Error updating document $e"),
                                        );
                                    await user.delete();
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        child: WelcomePage(),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.black),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "DELETE",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icons.delete_forever,
                      )
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
                              builder: (context) => UpdatePasswordPage(),
                            ),
                          );
                        },
                        icon: Icons.lock,
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
