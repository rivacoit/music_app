import 'package:flutter/material.dart';
import 'package:music_app/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _profilered() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd4d8f0),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.person),
                  iconSize: 40,
                  color: const Color(0xff232946),
                  onPressed: _profilered,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
