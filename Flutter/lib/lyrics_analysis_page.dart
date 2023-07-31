import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LyricsAnalysisPage extends StatefulWidget {
  const LyricsAnalysisPage({super.key});

  @override
  State<LyricsAnalysisPage> createState() => _LyricsAnalysisPageState();
}

class _LyricsAnalysisPageState extends State<LyricsAnalysisPage> {
  String lyrics = '';
  String keywords = '';

  void _analyzeLyrics() async {
    // Implement the backend connection here
    final String backendUrl = 'http://10.0.2.2:5000';

    final Map<String, String> data = {
      'lyrics': lyrics,
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

        // Assuming 'keywords' is a List of keywords
        List<dynamic> keywordsList = decodeResponse['keywords'];

        // Convert the List of keywords into a single String representation
        String keywordsString =
            keywordsList.join(', '); // Join the keywords with a comma and space

        // Update the 'keywords' variable with the String representation
        setState(() {
          keywords = keywordsString;
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  lyrics = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter lyrics here...',
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                _analyzeLyrics();
              },
              child: Text('Analyze Lyrics'),
            ),
            SizedBox(height: 10.0),
            Text('Keywords:'),
            Text(keywords),
          ],
        ),
      ),
    );
  }
}
