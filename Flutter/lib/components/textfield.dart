// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: TextField(
        autofocus: false,
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          hintStyle: TextStyle(
            fontFamily: "Poppins",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF232946),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF232946),
              width: 3,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF232946),
              width: 3,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(0),
            ),
          ),
        ),
      ),
    );
  }
}

// class ToggleText extends StatelessWidget {
//   final controller;
//   final String hintText;
//    bool obscureText;
//   const ToggleText({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     required this.obscureText,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 300,
//       height: 50,
//       child: TextField(
//         autofocus: false,
//         obscureText: obscureText,
//         controller: controller,
//         decoration: InputDecoration(
//           suffixIcon: IconButton(
//               icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
//               onPressed: () {
//                 setState(() {
//                   obscureText = !obscureText; //change boolean value
//                 });
//               }),
//           hintText: hintText,
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 15.0,
//             vertical: 15.0,
//           ),
//           hintStyle: TextStyle(
//             fontFamily: "Poppins",
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF232946),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Color(0xFF232946),
//               width: 3,
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(0),
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Color(0xFF232946),
//               width: 3,
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(0),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
