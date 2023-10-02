// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/components/marquee.dart';
import 'package:music_app/profile.dart';
import 'package:page_transition/page_transition.dart';

class SavedSongs extends StatefulWidget {
  const SavedSongs({super.key});

  @override
  State<SavedSongs> createState() => _SavedSongsState();
}

class _SavedSongsState extends State<SavedSongs> {
  QuerySnapshot? docSnapshot;

  @override
  void initState() {
    super.initState();
    getSavedSongs();
  }

  Future<void> getSavedSongs() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.isAnonymous) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('userInfo')
            .doc(user.uid)
            .collection("Saved Songs")
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
                ));
          },
        ),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      // ignore: prefer_const_constructors
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          20,
        ),
        // ignore: prefer_const_constructors
        child: Column(
          children: [
            Align(
              child: Text(
                "Saved songs",
              ),
              alignment: Alignment.center,
            ),
            docSnapshot == null
                ? CircularProgressIndicator()
                : docSnapshot!.docs.isEmpty
                    ? Text('No Saved Songs Found')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: docSnapshot!.docs.length,
                        itemBuilder: (context, index) {
                          final document = docSnapshot!.docs[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 0,
                            ),
                            child: ListTile(
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
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Color(0xFF232946),
                                ),
                                onPressed: () async {},
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
