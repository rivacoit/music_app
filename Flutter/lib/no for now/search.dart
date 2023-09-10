// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:music_app/components/textfield.dart';
import 'package:music_app/emotion_prediction_page.dart';
import 'package:music_app/home_page.dart';
import 'package:music_app/nlp_page.dart';
import 'package:page_transition/page_transition.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _inputcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void _search() {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: EmotionPredictionPage(),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFfffffe),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 25,
                      color: Color(0xFf232946),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: HomePage(),
                            type: PageTransitionType.leftToRight,
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: MyTextField(
                      controller: _inputcontroller,
                      hintText: "Search",
                      obscureText: false,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      iconSize: 25,
                      color: Color(0xFf232946),
                      onPressed: _search,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
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
      ),
    );
  }
}
