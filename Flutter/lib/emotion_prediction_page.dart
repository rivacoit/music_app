import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Emotion Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    inputText = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Enter text here...',
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _predictEmotionAndFetchSongs,
                child: const Text('Predict'),
              ),
              const SizedBox(height: 10.0),
              predictedEmotion.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Predicted Emotion: $predictedEmotion'),
                          const SizedBox(height: 10.0),
                          const Text('Recommended Songs:'),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: recommendedSongs.length,
                            itemBuilder: (context, index) {
                              String title =
                                  recommendedSongs.keys.elementAt(index);
                              return Card(
                                child: ListTile(
                                    title: Text(title),
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
                  : const Text('Tell me a story to predict your emotion'),
            ],
          ),
        ),
      ),
    );
  }
}
