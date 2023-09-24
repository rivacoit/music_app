// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:music_app/anonymous_profile.dart';
import 'package:music_app/components/listtiles.dart';
import 'package:music_app/components/marquee.dart';
import 'package:music_app/emotion_prediction_page.dart';
import 'package:music_app/profile.dart';
import 'package:music_app/no%20for%20now/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> exploreContent = [
    {
      "topic": "Imposter Syndrome",
      "songs": ["this is me trying", "Liability"],
      "artists": ["Taylor Swift", "idr"],
    },
    {
      "topic": "Friendship Fallout",
      "songs": ["I Lost a Friend", "How to Lose a Friend"],
      "artists": ["FINNEAS", "no clue tbh"],
    },
  ];
  void initState() {
    exploreContent.shuffle();
    super.initState();
  }

  void _profilered() async {
    if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AnonymousProfilePage(),
        ),
      );
    }
  }

  void _searchred() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmotionPredictionPage(),
      ),
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeebbc3),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _searchred,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(
                            9,
                          ),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Color(0xfffffffe),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Search for songs",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Color(0xFf232946),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.person),
                      iconSize: 40,
                      color: Color(0xfffffffe),
                      onPressed: _profilered,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  greeting(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xff232946),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
