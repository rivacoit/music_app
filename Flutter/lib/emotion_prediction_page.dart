import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmotionPredictionPage extends StatefulWidget {
  const EmotionPredictionPage({super.key});

  @override
  State<EmotionPredictionPage> createState() => _EmotionPredictionPageState();
}

class _EmotionPredictionPageState extends State<EmotionPredictionPage> {
  String userInput = '';
  String predictedEmotion = '';

  void _predictEmotion() async {
    const String backendUrl = 'http://10.0.2.2:5000';

    final Map<String, String> data = {
      'text': userInput,
    };

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      // Check if the request went through successfully
      if (response.statusCode == 200) {
        final decodeResponse = json.decode(response.body);

        setState(() {
          predictedEmotion = decodeResponse['emotion'];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  userInput = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter text here...',
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                _predictEmotion();
              },
              child: const Text('Predict Emotion'),
            ),
            const SizedBox(height: 10.0),
            const Text('Predicted Emotion:'),
            Text(predictedEmotion),
          ],
        ),
      ),
    );
  }
}
