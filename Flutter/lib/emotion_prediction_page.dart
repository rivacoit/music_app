// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:music_app/components/marquee.dart';
import 'package:music_app/home_page.dart';
import 'dart:convert';

import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmotionPredictionPage extends StatefulWidget {
  const EmotionPredictionPage({super.key});

  @override
  State<EmotionPredictionPage> createState() => _EmotionPredictionPageState();
}

class _EmotionPredictionPageState extends State<EmotionPredictionPage> {
  String inputText = '';
  String predictedEmotion = '';
  Map<String, dynamic> recommendedSongs = {};

  Future<void> _predictEmotionAndFetchSongs() async {
    const String backendUrl = 'http://127.0.0.1:5000';

    final Map<String, String> data = {
      'text': inputText,
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
                  : Column(
                      children: const [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Recent searches",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Color(0xff232946),
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
