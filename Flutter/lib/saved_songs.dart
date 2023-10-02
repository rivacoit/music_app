// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/profile.dart';
import 'package:page_transition/page_transition.dart';

class SavedSongs extends StatefulWidget {
  const SavedSongs({super.key});

  @override
  State<SavedSongs> createState() => _SavedSongsState();
}

class _SavedSongsState extends State<SavedSongs> {
  void getSavedSongs() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.isAnonymous) {
        String userId = user.uid;

        DocumentReference userSavedSongs = FirebaseFirestore.instance
            .collection('userInfo')
            .doc(userId)
            .collection("Saved Songs")
            .doc(title);
      } else {}
    } catch (e) {
      print('Error retreiving saved songs: $e');
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: recommendedSongs.length,
              itemBuilder: (context, index) {
                String title = recommendedSongs.keys.elementAt(index);
                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 0,
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFF232946), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: SizedBox(
                      width: 200.0,
                      child: MarqueeWidget(
                        direction: Axis.horizontal,
                        child: Text(
                          title,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFF232946),
                      ),
                      onPressed: () async {
                        try {
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null && !user.isAnonymous) {
                            String userId = user.uid;

                            DocumentReference userRef = FirebaseFirestore
                                .instance
                                .collection('userInfo')
                                .doc(userId);

                            // Add the song to the 'Saved Songs' subcollection
                            String title =
                                recommendedSongs.keys.elementAt(index);

                            DocumentReference savedSongRef =
                                userRef.collection('Saved Songs').doc(title);

                            // Set the song data
                            await savedSongRef.set({
                              'title': title,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$title added to Saved Songs'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '$title failed to add to Saved Songs. Check that you are logged in.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          print('Error adding song: $e');
                        }
                        // Add a function that will add the song to the user's collection ('Saved Songs')
                        // Ideally stored in a collection called userInfo with the doc name as the user.id
                        // Make sure to do checks to see whether or not song already exists/saved in the 'Saved Songs'
                      },
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
