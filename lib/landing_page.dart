import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 140),
              Image.asset(
                'assets/images/logo.png',
                height: 270,
                width: 470,
                fit: BoxFit.fitHeight,
                alignment: Alignment(0, -90),
              ),
              Transform.translate(
                offset: Offset(0, 40),
                child: Text(
                  'Money',
                  style: GoogleFonts.poppins(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, 3),
                child: Text(
                  'Manager',
                  style: GoogleFonts.poppins(
                    fontSize: 64,
                    fontWeight: FontWeight.normal,
                    color: Color(0xffDDB130),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Transform.translate(
                offset: Offset(0, 60),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffDDB130),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 17,
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  child: Text(
                    'Get Start',
                    style: GoogleFonts.openSans(
                      color: Color(0xff362A84),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
