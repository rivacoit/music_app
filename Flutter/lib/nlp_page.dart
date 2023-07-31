import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dart_sentiment/dart_sentiment.dart';
import 'package:music_app/components/buttons.dart';
import 'package:music_app/components/textfield.dart';

class NlpPage extends StatefulWidget {
  const NlpPage({
    super.key,
    required this.userText,
  });
  final String userText;

  @override
  State<NlpPage> createState() => _NlpPageState(userText: userText);
}

class _NlpPageState extends State<NlpPage> {
  final String userText;

  @override
  _NlpPageState({
    required this.userText,
  });
  @override
  void initState() {
    super.initState();
    _analyzeAndStoreEmotion(userText);
  }

  String _detectedEmotion = '';

  void _analyzeAndStoreEmotion(String value) {
    String detectedEmotion;

    final sentiment = Sentiment();
    final sentimentResult = sentiment.analysis(value);

    if (sentimentResult["score"] >= 0.5) {
      detectedEmotion = 'Positive';
    } else if (sentimentResult["score"] <= -0.5) {
      detectedEmotion = 'Negative';
    } else {
      detectedEmotion = 'Neutral';
    }

    setState(() {
      _detectedEmotion = detectedEmotion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Text('Detected Emotion: $_detectedEmotion'),
          ],
        ),
      ),
    );
  }
}
