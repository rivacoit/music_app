// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:marquee/marquee.dart';
import 'package:music_app/anonymous_profile.dart';
import 'package:music_app/components/buttons.dart';
import 'package:music_app/components/listtiles.dart';
import 'package:music_app/components/marquee.dart';
import 'package:music_app/results_page.dart';
import 'package:music_app/profile.dart';
import 'package:music_app/saved_songs.dart';
import 'package:music_app/search.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> exploreContent = [
    {
      "topic": "Imposter Syndrome",
      "songs": ["this is me trying", "Liability", "Imposter Syndrome"],
      "artists": ["Taylor Swift", "Lorde", "Alexa Cappelli"],
    },
    {
      "topic": "Friendship Fallout",
      "songs": ["I Lost a Friend", "How to Lose a Friend"],
      "artists": ["FINNEAS", "Wafia"],
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
        builder: (context) => SearchPage(),
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

              // Create Explore Container
              Container(
                color: Color(0xfffffffe),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Explore",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color(0xff232946),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: exploreContent.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final topicData = exploreContent[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: index == 0 ? 0 : 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xff232946),
                            ),
                            child: Column(
                              children: [
                                // Title
                                Container(
                                  child: Text(
                                    topicData["topic"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xfffffffe),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10),

                                // Songs/Artists
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Container(
                                    width: 250,
                                    child: ListView.separated(
                                      itemCount: topicData["songs"].length,
                                      separatorBuilder: (BuildContext context,
                                          int songIndex) {
                                        return SizedBox(height: 10);
                                      },
                                      itemBuilder: (BuildContext context,
                                          int songIndex) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Color(0xfffffffe),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 150.0,
                                                child: MarqueeWidget(
                                                  direction: Axis.horizontal,
                                                  child: Text(
                                                    "${topicData["songs"][songIndex]}",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 90.0,
                                                child: MarqueeWidget(
                                                  direction: Axis.horizontal,
                                                  child: Text(
                                                    "${topicData["artists"][songIndex]}",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Text(
                                              //   "${topicData["songs"][songIndex]}",
                                              //   style: TextStyle(
                                              //     fontSize: 16,
                                              //     color: Color(0xff232946),
                                              //   ),
                                              // ),
                                              // Spacer(),
                                              // Text(
                                              //   "${topicData["artists"][songIndex]}",
                                              //   style: TextStyle(
                                              //     fontSize: 16,
                                              //     color: Color(0xff232946),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    child: Container(
                      color: Color(0xff232946),
                      child: HomeButton(
                        background: Color(0xff232946),
                        fontcolor: Color(0xfffffffe),
                        text: "Saved Songs",
                        onp: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SavedSongs(),
                            ),
                          );
                        },
                        size: 30,
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: Container(
                      color: Color(0xffb8c1ec),
                      child: HomeButton(
                        background: Color(0xffb8c1ec),
                        fontcolor: Color(0xff232946),
                        text: "Profile",
                        onp: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                        size: 25,
                      ),
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: Container(
                      color: Color(0xfffffffe),
                      child: HomeButton(
                        background: Color(0xfffffffe),
                        fontcolor: Color(0xff232946),
                        size: 25,
                        text: "Settings",
                        onp: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // StaggeredGridTile.count(
                  //   crossAxisCellCount: 4,
                  //   mainAxisCellCount: 2,
                  //   child: Container(
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
