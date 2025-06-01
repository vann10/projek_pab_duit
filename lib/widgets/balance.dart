import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget balance() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Available Balance",
          style: GoogleFonts.dmSans(color: Colors.green, fontSize: 20),
        ),
        Text(
          "Rp9.966.000,00",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 50),
        Image.asset('assets/images/percentage.png', width: 360),
      ],
    ),
  );
}
