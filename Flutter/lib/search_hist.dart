// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/profile.dart';
import 'package:music_app/results_page.dart';
import 'package:page_transition/page_transition.dart';

import 'components/marquee.dart';

class SearchHistPage extends StatefulWidget {
  const SearchHistPage({super.key});

  @override
  State<SearchHistPage> createState() => _SearchHistPageState();
}

class _SearchHistPageState extends State<SearchHistPage> {
  QuerySnapshot? docSnapshot;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getSearchHist();
  }

  Future<void> getSearchHist() async {
    try {
      if (user != null && !user!.isAnonymous) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('userInfo')
            .doc(user!.uid)
            .collection("Search History")
            .get();
        setState(() {
          docSnapshot = snapshot;
        });
      }
    } catch (e) {
      print('Error retreiving documents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff232946),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xFFfffffe),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFfffffe),
          ),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                  child: ProfilePage(),
                  type: PageTransitionType.leftToRight,
                ));
          },
        ),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          25,
        ),
        // ignore: prefer_const_constructors
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Searches",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xfffffffe),
                    fontFamily: "Poppins",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            docSnapshot == null
                ? CircularProgressIndicator()
                : docSnapshot!.docs.isEmpty
                    ? Text(
                        'No Search History Found',
                        style: TextStyle(
                          color: Color(0xfffffffe),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: docSnapshot!.docs.length,
                        itemBuilder: (context, index) {
                          final document = docSnapshot!.docs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultsPage(
                                            inputText: document.id,
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 0,
                              ),
                              child: ListTile(
                                tileColor: Color(0xfffffffe),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color(0xFF232946), width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: SizedBox(
                                  width: 200.0,
                                  child: MarqueeWidget(
                                    direction: Axis.horizontal,
                                    child: Text(
                                      document.id, // Display doc name
                                      style: TextStyle(
                                        color: Color(0xff232946),
                                      ),
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Color(0xff232946),
                                  ),
                                  onPressed: () async {
                                    if (user != null && !user!.isAnonymous) {
                                      String searchEntry = document.id;

                                      DocumentReference documentReference =
                                          FirebaseFirestore.instance
                                              .collection('userInfo')
                                              .doc(user!.uid)
                                              .collection("Search History")
                                              .doc(searchEntry);

                                      documentReference.delete();

                                      getSearchHist();
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
