import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget header(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 50.0, left: 20.0),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Image.asset(
            'assets/images/hamburger.png',
            width: 30,
            height: 30,
          ),
        ),
        SizedBox(width: 80),
        Text(
          "Welcome",
          style: GoogleFonts.syncopate(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
