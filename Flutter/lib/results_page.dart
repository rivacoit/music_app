// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:music_app/components/marquee.dart';
import 'package:music_app/home_page.dart';
import 'package:music_app/search.dart';
import 'dart:convert';

import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResultsPage extends StatefulWidget {
  ResultsPage({super.key, required this.inputText});
  String inputText;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  String predictedEmotion = '';
  Map<String, dynamic> recommendedSongs = {};

  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    _predictEmotionAndFetchSongs();
    super.initState();
  }

  void addHistory(String input) async {
    try {
      if (user != null && !user!.isAnonymous) {
        String userId = user!.uid;

        DocumentReference userRef =
            FirebaseFirestore.instance.collection('userInfo').doc(userId);

        CollectionReference searchHistRef =
            userRef.collection('Search History');

        QuerySnapshot historySnapshot =
            await searchHistRef.orderBy('timestamp', descending: true).get();

        if (historySnapshot.docs.length >= 5) {
          await historySnapshot.docs.last.reference.delete();
        }

        // Add new document
        await searchHistRef.doc(input).set({
          'search input': input,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error adding song: $e');
    }
  }

  Future<void> _predictEmotionAndFetchSongs() async {
    addHistory(widget.inputText);
    const String backendUrl = 'http://10.0.2.2:5000';
    // Addresses
    // Android: http://10.0.2.2:5000
    // iOS: http://127.0.0.1:5000

    final Map<String, String> data = {
      'text': widget.inputText,
    };

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/predict_emotion'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final decodeResponse = json.decode(response.body);
        setState(() {
          predictedEmotion = decodeResponse['emotion'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }

      final songsResponse = await http.get(
        Uri.parse('$backendUrl/recommendation?emotion=$predictedEmotion'),
      );

      if (songsResponse.statusCode == 200) {
        print(songsResponse.body);
        final decodeSongsResponse = json.decode(songsResponse.body);
        print(decodeSongsResponse);
        setState(() {
          recommendedSongs = decodeSongsResponse['recommended_songs'];
        });
      } else {
        print('Error fetching recommended songs: ${songsResponse.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
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
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                            width: 2.0,
                            color: Color(0xFf232946),
                          ),
                        ),
                        elevation: MaterialStatePropertyAll<double>(0),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.transparent),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        widget.inputText,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF232946),
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
                      onPressed: _predictEmotionAndFetchSongs,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              predictedEmotion.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Predicted Emotion: $predictedEmotion',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: recommendedSongs.length,
                            itemBuilder: (context, index) {
                              String title =
                                  recommendedSongs.keys.elementAt(index);
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
                                        User? user =
                                            FirebaseAuth.instance.currentUser;
                                        if (user != null && !user.isAnonymous) {
                                          String userId = user.uid;

                                          DocumentReference userRef =
                                              FirebaseFirestore.instance
                                                  .collection('userInfo')
                                                  .doc(userId);

                                          // Add the song to the 'Saved Songs' subcollection
                                          String title = recommendedSongs.keys
                                              .elementAt(index);

                                          DocumentReference savedSongRef =
                                              userRef
                                                  .collection('Saved Songs')
                                                  .doc(title);

                                          // Set the song data
                                          await savedSongRef.set({
                                            'title': title,
                                            'timestamp':
                                                FieldValue.serverTimestamp(),
                                          });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '$title added to Saved Songs'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                    )
                  : Text("data"),
            ],
          ),
        ),
      ),
    );
  }
}
