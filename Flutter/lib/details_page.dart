// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:genius_lyrics/genius_lyrics.dart';
import 'package:provider/provider.dart'; // Import Firestore

class DetailsPage extends StatefulWidget {
  final String songInfo;
  const DetailsPage({required this.songInfo});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String lyrics = "";
  Future<DocumentSnapshot<Map<String, dynamic>>> _getSongInfo() async {
    final QuerySnapshot<Map<String, dynamic>> emotionsCollection =
        await FirebaseFirestore.instance
            .collection('musicRecommendation')
            .get();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> emotionDocument
        in emotionsCollection.docs) {
      final data = emotionDocument.data();

      // Check if the emotion document contains the songInfo as a key
      if (data.containsKey(widget.songInfo)) {
        return emotionDocument;
      }
    }
    return Future.error('Song not found'); // Handle not found case
  }

  void getLyrics(String title, String artist) async {
    Genius genius = Genius(
        accessToken:
            "IXpLmMYu2hP40TG71dhbb81szVPVAxyOUAceeMYkpVVH23dOOG9kufcMDZr9xjyf");
    Song? song = (await genius.searchSong(artist: artist, title: title));

    if (song != null) {
      lyrics = (song.lyrics)!;
    } else {
      lyrics = "failed to retrieve lyrics";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFd4d8f0),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Song Details',
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 15,
            color: Color(0xff232946),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: _getSongInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text('Song not found');
              }

              final songData = snapshot.data!.data()?[widget.songInfo];

              if (songData == null) {
                return Text('Song not found');
              }

              final songName = songData['song_name'];
              final artist = (songData['artist'] as List<dynamic>)
                  .join(", "); // Convert list to string
              getLyrics(songName, artist);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$songName',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff232946),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$artist',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Color(0xfffffffe),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lyrics",
                          style: TextStyle(
                            color: Color(0xff232946),
                            fontFamily: "Poppins",
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          lyrics,
                          style: TextStyle(
                            color: Color(0xff232946),
                            fontFamily: "Poppins",
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      )),
    );
  }
}
