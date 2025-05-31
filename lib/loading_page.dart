import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/login');
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: Image.asset(
            'assets/images/logo.png',
            height: 500,
            width: 700,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
