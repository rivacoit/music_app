import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class DetailsPage extends StatefulWidget {
  final String songInfo;
  const DetailsPage({required this.songInfo});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
            final lyrics = songData['lyrics'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$songName',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$artist',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Lyrics: $lyrics',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
