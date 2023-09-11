import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SongRecPage extends StatefulWidget {
  const SongRecPage({Key? key}) : super(key: key);

  @override
  _SongRecPageState createState() => _SongRecPageState();
}

class _SongRecPageState extends State<SongRecPage> {
  String inputText = '';
  String predictedEmotion = '';
  Map<String, dynamic> recommendedSongsByEmotion = {};
  List<String> recommendedSongsByActivity = [];

  Future<void> _predictEmotionAndFetchSongs() async {
    const String backendUrl = 'http://10.0.2.2:5000';

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
        final decodeSongsResponse = json.decode(songsResponse.body);
        print(decodeSongsResponse);
        setState(() {
          recommendedSongsByEmotion = decodeSongsResponse['recommended_songs'];
        });
      } else {
        print('Error fetching recommended songs: ${songsResponse.statusCode}');
      }

      final songsByActivityResponse = await http.post(
        Uri.parse('$backendUrl/recommendation_by_activity'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (songsByActivityResponse.statusCode == 200) {
        final decodeSongsByActivityResponse =
            json.decode(songsByActivityResponse.body);
        setState(() {
          recommendedSongsByActivity = List<String>.from(
              decodeSongsByActivityResponse['recommended_songs']);
        });
      } else {
        print(
            'Error fetching recommended songs by activity: ${songsByActivityResponse.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song Recommendations'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Tell your story",
              ),
            ),
            ElevatedButton(
              onPressed: _predictEmotionAndFetchSongs,
              child: Text('Get Song Recommendations'),
            ),
            SizedBox(height: 20),
            Text('Predicted Emotion: $predictedEmotion'),
            Text('Recommended Songs by Emotion:'),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: recommendedSongsByEmotion.length,
                itemBuilder: (context, index) {
                  String title =
                      recommendedSongsByEmotion.keys.elementAt(index);
                  return Card(
                    child: ListTile(
                        title: Text(title),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {},
                        )),
                  );
                },
              ),
            ),
            Text('Recommended Songs by Activity:'),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: recommendedSongsByActivity.length,
                itemBuilder: (context, index) {
                  String songTitle = recommendedSongsByActivity[index];
                  return Card(
                    child: ListTile(
                        title: Text(songTitle),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {},
                        )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
