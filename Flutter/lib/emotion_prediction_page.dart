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
  List<String> recommendedSongs = [];

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
        setState(() {
          recommendedSongs = List<String>.from(
            decodeSongsResponse['recommended_songs'],
          );
        });
      } else {
        print('Error fecting recommended songs: ${songsResponse.statusCode}');
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
        title: Text('Emotion Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter text here...',
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _predictEmotionAndFetchSongs,
              child: Text('Predict'),
            ),
            SizedBox(height: 10.0),
            Text('Predicted Emotion: $predictedEmotion'),
            SizedBox(height: 10.0),
            Text('Recommended Songs:'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: recommendedSongs.length,
              itemBuilder: (context, index) {
                return Text(recommendedSongs[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
