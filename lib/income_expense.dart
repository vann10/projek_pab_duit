import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IncomeExpense extends StatelessWidget {
  const IncomeExpense({super.key});

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
                  center: Alignment(-1.0, -1.5),
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
            ]
            ),
        ],
      ),
    );
  }
}


Widget Header(){
  return Padding(padding: const EdgeInsets.only(
      top: 80.0,
      left: 20.0,
    ),
    child: Row(children: [
      Image.asset('assets/images/close.png')
    ],),);

}