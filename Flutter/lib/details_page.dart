// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:genius_lyrics/genius_lyrics.dart';
import 'package:music_app/components/buttons.dart';
import 'package:provider/provider.dart'; // Import Firestore
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:spotify/spotify.dart' as spotify;
import 'package:uni_links/uni_links.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:jwt_decode/jwt_decode.dart';

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

  listenOnSpotify(String songName, String artist) async {
    try {
      var spotifyApi = _getSpotifyApi();
      var searchResults =
          await spotifyApi.search.get('$songName $artist').first(1);

      searchResults.forEach((pages) {
        if (pages.items == null) {
          print('Empty items');
        }
        pages.items!.forEach((item) async {
          if (item is spotify.Track) {
            print('id: ${item.id}\n'
                'name: ${item.name}\n');

            var trackUrl = 'https://open.spotify.com/track/${item.id}';
            if (await canLaunch(trackUrl)) {
              await launch(trackUrl);
            } else {
              print('Could not launch $trackUrl');
            }
          }
        });
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accessing Spotify'),
        ),
      );
    }
  }

  Future<void> addToSpotifyPlaylist(String songName, String artist,
      String accessToken, String refreshToken) async {
    try {
      print('Getting SpotifyAPI');
      var spotifyApi = _getSpotifyApiWithToken(accessToken, refreshToken);
      print('SpotifyAPI retrieved.');

      // var playlist = playlists.first(1);

      // print(playlists);

      // print('Playlist retrieved.');
      // print(playlist);

      print('Search Query: $songName $artist');

      var searchResults =
          await spotifyApi.search.get('$songName $artist').first(1);

      // print(searchResults);

      print('searchResults retrieved.');

      searchResults.forEach((pages) {
        pages.items!.forEach((item) async {
          if (item is spotify.Track) {
            print('id: ${item.id}\n'
                'name: ${item.name}\n');

            // var decodedToken = Jwt.parseJwt(accessToken);
            // var userId = decodedToken['sub'];

            // print('Decoded Token');

            var userId;
            try {
              userId = getUserId(accessToken);
            } catch (e) {
              print('Error getting userId: $e');
              return;
            }

            // var playlists = spotifyApi.playlists.getUsersPlaylists(userId);

            var resonancePlaylist = await spotifyApi.playlists.createPlaylist(
                userId, 'Resonance',
                description:
                    'This is a generated playlist for the app Resonance.');

            print('Generated playlist');

            await spotifyApi.playlists
                .addTrack([item.uri] as String, resonancePlaylist.id!);

            print('Added to playlist');

            // if (await canLaunch(trackUrl)) {
            //   await launch(trackUrl);
            // } else {
            //   print('Could not launch $trackUrl');
            // }
          }
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> getUserId(String accessToken) async {
    print('ABOUT TO RESPOND');
    var response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me'),
      headers: {'Authorization': 'Bearer $accessToken'},
    ).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      print('RESPONDED');
      var body = json.decode(response.body);
      return body['id'];
    } else {
      throw Exception('Failed to fetch user profile: ${response.statusCode}');
    }
  }

  listen(String redirectUri) async {
    final responseUri = await launch(redirectUri, forceWebView: true);

    if (responseUri != null) {
      return responseUri;
    } else {
      throw Exception('Failed authorization.');
    }
  }

  // Helper function to get Spotify API instance
  spotify.SpotifyApi _getSpotifyApi() {
    // var keyJson = File('../key.json').readAsStringSync();
    // var keyMap = json.decode(keyJson);
    var credentials = spotify.SpotifyApiCredentials(
        '0ad20df5fb67498da3ff35945ee37942', 'bb3625e4891247a38be5d5fdaba4275b');
    // var credentials =
    //     spotify.SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
    return spotify.SpotifyApi(credentials);
  }

  spotify.SpotifyApi _getSpotifyApiWithToken(
      String accessToken, String refreshToken) {
    var credentials = spotify.SpotifyApiCredentials(
        '0ad20df5fb67498da3ff35945ee37942', 'bb3625e4891247a38be5d5fdaba4275b',
        accessToken: accessToken, refreshToken: refreshToken);
    var spotifyApi = spotify.SpotifyApi(credentials);

    // // Check if the access token is expired
    // if (credentials.isExpired) {
    //   // If expired, refresh the access token using the refresh token
    //   credentials.refreshToken!;
    //   print('Token refreshed');

    //   // Update the Spotify API instance with the new access token
    //   spotifyApi = spotify.SpotifyApi(credentials);
    // }

    return spotifyApi;
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
                  child: CircularProgressIndicator(
                    color: Color(0xff232946),
                  ),
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
                  child: CircularProgressIndicator(
                    color: Color(0xff232946),
                  ),
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
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                              SizedBox(height: 5),
                              Text(
                                '$artist',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                        // Column(
                        //   children: [
                        //     SizedBox(
                        //       height: 50,
                        //       width: 80,
                        //       child: ElevatedButton(
                        //         style: ButtonStyle(
                        //           shape: MaterialStateProperty.all<
                        //               RoundedRectangleBorder>(
                        //             RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(0),
                        //             ),
                        //           ),
                        //           backgroundColor:
                        //               MaterialStatePropertyAll<Color>(
                        //             Color(0xffeebbc3),
                        //           ),
                        //         ),
                        //         child: Text(
                        //           "Listen on\nSpotify",
                        //           style: TextStyle(
                        //             color: Color(0xFF232946),
                        //             fontFamily: "Poppins",
                        //             fontWeight: FontWeight.w300,
                        //             fontSize: 17,
                        //           ),
                        //         ),
                        //         onPressed: () {
                        //           listenOnSpotify(songName, artist);
                        //         },
                        //       ),
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ButtonOne(
                      func: () {
                        listenOnSpotify(songName, artist);
                      },
                      text: 'Listen on Spotify',
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final appAuth = FlutterAppAuth();

                        print('Start authorization request...');

                        final AuthorizationTokenResponse? result =
                            await appAuth.authorizeAndExchangeCode(
                          AuthorizationTokenRequest(
                            '0ad20df5fb67498da3ff35945ee37942',
                            'resonanceapp://callback',
                            discoveryUrl:
                                'https://accounts.spotify.com/.well-known/openid-configuration',
                            scopes: <String>[
                              'user-read-private',
                              'playlist-modify-public',
                              // 'playlist-modify-private',
                              // 'playlist-read-collaborative',
                              // 'playlist-read-private',
                            ],
                            clientSecret: 'bb3625e4891247a38be5d5fdaba4275b',
                          ),
                        );

                        print('Access Token: ${result!.accessToken}');
                        print('Access Scopes: ${result.scopes}');
                        print(
                            'Access Expire Time: ${result.accessTokenExpirationDateTime}');

                        if (result != null &&
                            result.accessToken != null &&
                            result.refreshToken != null) {
                          print('Authorization successful!');
                          addToSpotifyPlaylist(songName, artist,
                              result.accessToken!, result.refreshToken!);
                        } else {
                          print('Error');
                        }
                      },
                      child: Text('Add to Spotify Playlist'),
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
