import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 500,
                  width: 700,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment(0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
