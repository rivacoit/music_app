// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonOne extends StatelessWidget {
  final String text;
  final Function()? func;
  const ButtonOne({
    super.key,
    required this.text,
    required this.func,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: func,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll<Color>(
            Color(0xffeebbc3),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF232946),
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}

class ButtonTwo extends StatelessWidget {
  final String text;
  final Function()? func;
  const ButtonTwo({
    super.key,
    required this.text,
    required this.func,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: func,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll<Color>(
            Color(0xFFfffffe),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF232946),
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class LogoButton extends StatelessWidget {
  final FaIcon logo;
  final Function()? func;
  const LogoButton({
    super.key,
    required this.logo,
    required this.func,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: func,
        icon: logo,
        label: Text(
          "Continue with Google",
          style: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xFF232946),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll<Color>(
            Color(0xFFeebbc3),
          ),
        ),
      ),
    );
  }
}
