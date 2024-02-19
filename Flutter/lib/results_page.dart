// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:music_app/components/marquee.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/search.dart';
import 'package:page_transition/page_transition.dart';

import 'details_page.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key, required this.inputText});
  final String inputText;

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

  Future<Set<String>> getSavedSongs() async {
    Set<String> savedSongs = {};

    try {
      if (user != null && !user!.isAnonymous) {
        String userID = user!.uid;

        DocumentReference userRef =
            FirebaseFirestore.instance.collection('userInfo').doc(userID);

        QuerySnapshot savedSongsSnapshot =
            await userRef.collection('Saved Songs').get();

        savedSongs = savedSongsSnapshot.docs.map((doc) => doc.id).toSet();
      }
    } catch (e) {
      print('Error $e');
    }

    return savedSongs;
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

      // final songsResponse = await http.get(
      //   Uri.parse('$backendUrl/recommendation?emotion=$predictedEmotion'),
      // );

      final String userInputText = widget.inputText;

      final songsResponse = await http.get(
        Uri.parse(
            '$backendUrl/recommendation_by_activity?emotion=$predictedEmotion&userinput=$userInputText'),
      );

      if (songsResponse.statusCode == 200) {
        print(songsResponse.body);
        final decodeSongsResponse = json.decode(songsResponse.body);
        // print(decodeSongsResponse);
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
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: SearchPage(),
                          type: PageTransitionType.leftToRight,
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
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
                              return FutureBuilder<Set<String>>(
                                  future: getSavedSongs(),
                                  builder: (context, snapshot) {
                                    Set<String> userSavedSongs =
                                        snapshot.data ?? {};

                                    bool isSongSaved =
                                        userSavedSongs.contains(title);

                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 6,
                                      ),
                                      child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color(0xFF232946),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          title: ElevatedButton(
                                            style: ButtonStyle(
                                              elevation:
                                                  MaterialStatePropertyAll<
                                                      double>(0.0),
                                              backgroundColor:
                                                  MaterialStatePropertyAll<
                                                          Color>(
                                                      Colors.transparent),
                                              padding: MaterialStatePropertyAll<
                                                  EdgeInsetsGeometry>(
                                                EdgeInsets.fromLTRB(
                                                  4,
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: MarqueeWidget(
                                                direction: Axis.horizontal,
                                                child: Text(
                                                  title,
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsPage(
                                                          songInfo: title),
                                                ),
                                              );
                                            },
                                          ),
                                          trailing: SizedBox(
                                            height: 45,
                                            width: 45,
                                            child: LikeButton(
                                              isLiked: isSongSaved,
                                              onTap: (isLiked) async {
                                                if (isLiked) {
                                                  User? user = FirebaseAuth
                                                      .instance.currentUser;
                                                  if (user != null &&
                                                      !user.isAnonymous) {
                                                    String userId = user.uid;

                                                    DocumentReference userRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'userInfo')
                                                            .doc(userId);

                                                    String title =
                                                        recommendedSongs.keys
                                                            .elementAt(index);
                                                    DocumentReference
                                                        savedSongRef = userRef
                                                            .collection(
                                                                'Saved Songs')
                                                            .doc(title);
                                                    await savedSongRef.delete();

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            '$title deleted from Saved Songs'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  try {
                                                    User? user = FirebaseAuth
                                                        .instance.currentUser;
                                                    if (user != null &&
                                                        !user.isAnonymous) {
                                                      String userId = user.uid;

                                                      DocumentReference userRef =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'userInfo')
                                                              .doc(userId);

                                                      // Add the song to the 'Saved Songs' subcollection
                                                      String title =
                                                          recommendedSongs.keys
                                                              .elementAt(index);

                                                      DocumentReference
                                                          savedSongRef = userRef
                                                              .collection(
                                                                  'Saved Songs')
                                                              .doc(title);

                                                      // Set the song data
                                                      await savedSongRef.set({
                                                        'title': title,
                                                        'timestamp': FieldValue
                                                            .serverTimestamp(),
                                                      });

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              '$title added to Saved Songs'),
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              '$title failed to add to Saved Songs. Check that you are logged in.'),
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    print(
                                                        'Error adding song: $e');
                                                  }
                                                }
                                                return !isLiked;
                                              },
                                              size: 40,
                                              circleColor: CircleColor(
                                                start: Color(0xffeebbc3),
                                                end: Color(0xffeebbc3),
                                              ),
                                              bubblesColor: BubblesColor(
                                                dotPrimaryColor:
                                                    Color(0xFf232946),
                                                dotSecondaryColor:
                                                    Color(0xffb8c1ec),
                                              ),
                                              likeBuilder: (bool isLiked) {
                                                // return Icon(
                                                //   Icons.favorite,
                                                //   color: isLiked
                                                //       ? Color(0xFf232946)
                                                //       : Colors.grey,
                                                //   size: 25,
                                                // );
                                                return isLiked
                                                    ? Icon(
                                                        Icons.favorite,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 239, 86, 75),
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                        color: Colors.grey,
                                                      );
                                              },
                                            ),
                                          )),
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    )
                  : Text("Error reaching the server. Please try again later."),
            ],
          ),
        ),
      ),
    );
  }
}
