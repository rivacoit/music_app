// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/results_page.dart';
import 'package:music_app/home_page.dart';
import 'package:page_transition/page_transition.dart';

import 'components/marquee.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  User? user = FirebaseAuth.instance.currentUser;
  QuerySnapshot? docSnapshot;
  String inputText = "";

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  Future<void> getHistory() async {
    try {
      if (user != null && !user!.isAnonymous) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('userInfo')
            .doc(user!.uid)
            .collection("Search History")
            .orderBy('timestamp', descending: true)
            .get();
        setState(() {
          docSnapshot = snapshot;
        });
      }
    } catch (e) {
      print('Error retreiving documents: $e');
    }
  }

  void _search(String input) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: ResultsPage(
          inputText: input,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFd4d8f0),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 25,
                      color: Color(0xFf232946),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: HomePage(),
                            type: PageTransitionType.leftToRight,
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 300,
                      height: 40,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            inputText = value;
                          });
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Tell your story",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 10.0,
                          ),
                          hintStyle: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF232946),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF232946),
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF232946),
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(0),
                            ),
                          ),
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
                      icon: const Icon(Icons.search),
                      iconSize: 25,
                      color: Color(0xFf232946),
                      onPressed: () {
                        _search(inputText);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Recent searches",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Color(0xff232946),
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FirebaseAuth.instance.currentUser!.isAnonymous
                      ? Text(
                          "You are logged in as guest and cannot view your search history.")
                      : docSnapshot == null
                          ? CircularProgressIndicator(
                              color: Color(0xff232946),
                            )
                          : docSnapshot!.docs.isEmpty
                              ? Text('No search history.')
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: docSnapshot!.docs.length,
                                  itemBuilder: (context, index) {
                                    final document = docSnapshot!.docs[index];
                                    return GestureDetector(
                                      onTap: () {
                                        _search(document.id);
                                      },
                                      child: Container(
                                          child: Column(
                                        children: [
                                          ListTile(
                                            tileColor: Colors.transparent,
                                            title: SizedBox(
                                              width: 200.0,
                                              child: MarqueeWidget(
                                                direction: Axis.horizontal,
                                                child: Text(
                                                  document
                                                      .id, // Display doc name
                                                  style: TextStyle(
                                                    color: Color(0xff232946),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                            color: Color(0xFF232946),
                                          ),
                                        ],
                                      )),
                                    );
                                  },
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
