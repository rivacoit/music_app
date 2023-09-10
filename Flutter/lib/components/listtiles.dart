import 'package:flutter/material.dart';

class SongTileOne extends StatelessWidget {
  final String songName;
  final String artistName;
  const SongTileOne({
    super.key,
    required this.songName,
    required this.artistName,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              songName,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 13,
                color: Color(0xfffffffe),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              artistName,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 9,
                color: Color(0xfffffffe),
              ),
            ),
          )
        ],
      ),
      trailing: IconButton(
        color: Color(0xfffffffe),
        icon: const Icon(Icons.play_arrow),
        onPressed: () {},
      ),
    );
  }
}
