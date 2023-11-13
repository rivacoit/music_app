// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:genius_lyrics/genius_lyrics.dart';
import 'package:provider/provider.dart'; // Import Firestore
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  final String songInfo;
  const DetailsPage({required this.songInfo});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String lyrics = "";
  bool lyricsLoading = true;
  bool lyricsLoaded = false;
  String albumCoverUrl = "";

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
    if (lyricsLoaded || !mounted) {
      return;
    }

    Genius genius = Genius(
        accessToken:
            "IXpLmMYu2hP40TG71dhbb81szVPVAxyOUAceeMYkpVVH23dOOG9kufcMDZr9xjyf");
    Song? song = (await genius.searchSong(artist: artist, title: title));

    if (!mounted) {
      return;
    }

    if (song != null) {
      setState(() {
        lyrics = song.lyrics!;
        lyricsLoading = false;
        lyricsLoaded = true;
        albumCoverUrl = song.songArtImageUrl ?? "";
      });
    } else {
      setState(() {
        lyrics = "failed to retrieve lyrics";
        lyricsLoading = false;
      });
    }
  }

  final FlutterAppAuth appAuth = FlutterAppAuth();
  final String clientId = '0ad20df5fb67498da3ff35945ee37942';
  final String clientSecret = 'a00088fd258446ec824830d1e37a3e1d';
  final String redirectUrl = 'https://example.com/auth';

  listenOnSpotify(String songName, String artist) async {
    try {
      // Spotify Authentication
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          issuer: 'https://accounts.spotify.com',
          discoveryUrl:
              'https://accounts.spotify.com/.well-known/openid-configuration',
          scopes: <String>['user-library-read'],
        ),
      );

      if (result != null) {
        final searchResponse = await http.get(
          Uri.parse(
              'https://api.spotify.com/v1/search?q=$songName%20$artist&type=track'),
          headers: {
            'Authorization': 'Bearer ${result.accessToken}',
          },
        );

        if (searchResponse.statusCode == 200) {
          final searchData = json.decode(searchResponse.body);
          final tracks = searchData['tracks']['items'];

          if (tracks.isNotEmpty) {
            final trackId = tracks[0]['id'];
            final trackUrl = 'https://open.spotify.com/track/$trackId';
            launch(trackUrl);
          }
        }
      }
    } catch (e) {
      print('Error: $e');
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
                return Center(
                  child: CircularProgressIndicator(),
                );
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

              if (lyricsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (lyricsLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    if (albumCoverUrl.isNotEmpty)
                      Center(
                        child: Image.network(
                          albumCoverUrl,
                          width: 250,
                          height: 250,
                        ),
                      ),
                    SizedBox(height: 30),
                    Text(
                      '$songName',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff232946),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '$artist',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        listenOnSpotify(songName, artist);
                      },
                      child: Text('Listen on Spotify'),
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                  ],
                );
              } else {
                return Text('Failed to load page.');
              }
            },
          ),
        ),
      )),
    );
  }
}
