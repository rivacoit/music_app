// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/home_page.dart';
import 'dart:convert';

import 'package:page_transition/page_transition.dart';

class SongRecTestPage extends StatefulWidget {
  const SongRecTestPage({super.key});

  @override
  State<SongRecTestPage> createState() => _SongRecTestPageState();
}

class _SongRecTestPageState extends State<SongRecTestPage> {
  String inputText = '';
  String predictedEmotion = '';
  List<String> recommendedSongs = [];

  Future<void> _fetchSongsByActivity() async {
    const String backendUrl = 'http://10.0.2.2:5000';
    // Android: http://10.0.2.2:5000
    // IOS: http://127.0.0.1:5000

    final Map<String, String> data = {
      'text': inputText,
    };

    try {
      final songsResponse = await http.post(
        Uri.parse('$backendUrl/recommendation_by_activity'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (songsResponse.statusCode == 200) {
        final decodeSongsResponse = json.decode(songsResponse.body);
        print(decodeSongsResponse);
        if (decodeSongsResponse.containsKey('recommended_songs')) {
          final recommendedSongsList = decodeSongsResponse['recommended_songs'];
          setState(() {
            recommendedSongs = List<String>.from(recommendedSongsList);
          });
        }
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
      backgroundColor: Color(0xFFfffffe),
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
                      onPressed: _fetchSongsByActivity,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              recommendedSongs.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          // Text('Predicted Emotion: $predictedEmotion'),
                          // const SizedBox(height: 10.0),
                          const Text('Recommended Songs:'),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: recommendedSongs.length,
                            itemBuilder: (context, index) {
                              String songTitle = recommendedSongs[index];
                              return Card(
                                child: ListTile(
                                    title: Text(songTitle),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.play_arrow),
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           AudioPlayerScreen(
                                        //             audioUrl:
                                        //                 recommendedSongs[title]
                                        //                     ['song_url'],
                                        //             lyrics:
                                        //                 recommendedSongs[title]
                                        //                     ['lyrics'],
                                        //             title: title,
                                        //           )),
                                        // );
                                      },
                                    )),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: const [
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
