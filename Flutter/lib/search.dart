// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:music_app/nlp_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xFF232946),
        ),
        leading: BackButton(),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFFfffffe),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.0,
            ),
            SizedBox(
              width: 300,
              height: 100,
              child: TextField(
                onSubmitted: (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NlpPage(userText: value),
                    ),
                  );
                },
                autofocus: false,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffb8c1ec),
                ),
                decoration: InputDecoration(
                  hintText: "tell your story...",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Color(0xFF232946),
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffb8c1ec),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Text(
                "Recent searches",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Color(0xff232946),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
