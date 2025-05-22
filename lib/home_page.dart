import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(1.0, 1.0),
                  radius: 1,
                  colors: [
                    Color(0xFF141326),
                    Color.fromARGB(255, 64, 134, 232),
                    Color(0xFF141326),
                  ],
                  stops: [0.0, 0.7, 1],
                ),
              ),
            ),
          ),

          Column(children: [
            Header(),
            SizedBox(height: 50),
            Balance()
            ]
            ),
        ],
      ),
    );
  }
}

Widget Header() {
  return Padding(
    padding: const EdgeInsets.only(
      top: 80.0,
      left: 20.0,
    ), // atur jarak dari atas
    child: Row(
      // optional: untuk posisi tengah horizontal
      children: [
        Image.asset('assets/images/hamburger.png', width: 30, height: 30),
        SizedBox(width: 80),
        Text(
          "Welcome",
          style: GoogleFonts.syncopate(
            // atau roboto, lato, dsb.
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}


Widget Balance() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Available Balance",
          style: GoogleFonts.dmSans(
            color: Colors.green,
            fontSize: 20,
          ),
        ),
        Text(
          "Rp3.000.000,00",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
