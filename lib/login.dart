import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_pab_duit/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String enteredPin = '';
  bool isPinVisible = false;
  bool isPinWrong = false;

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPin.length < 4) {
              enteredPin += number.toString();

              if (enteredPin.length == 4) {
                if (enteredPin == '1234') {
                  isPinWrong = false;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  });
                } else {
                  isPinWrong = true;
                  Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() {
                      enteredPin = '';
                    });
                  });
                }
              }
            }
          });
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200),

            // Pesan judul PIN
            Text(
              isPinWrong ? "PIN Salah" : "Masukkan PIN Anda",
              style: GoogleFonts.dmSans(
                color: isPinWrong ? Colors.red : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),

            // Kotak PIN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 23),
                  width: isPinVisible ? 50 : 16,
                  height: isPinVisible ? 50 : 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: index < enteredPin.length
                        ? isPinVisible
                            ? const Color.fromARGB(255, 0, 106, 255)
                            : CupertinoColors.activeBlue
                        : CupertinoColors.activeBlue.withOpacity(0.1),
                  ),
                  child: isPinVisible && index < enteredPin.length
                      ? Center(
                          child: Text(
                            enteredPin[index],
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : null,
                );
              }),
            ),

            const SizedBox(height: 50),

            // Tombol toggle PIN terlihat/sembunyi
            IconButton(
              onPressed: () {
                setState(() {
                  isPinVisible = !isPinVisible;
                });
              },
              icon: Icon(
                isPinVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Tombol angka 1-9
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      List.generate(3, (index) => numButton(1 + 3 * i + index)),
                ),
              ),

            // Tombol 0 dan backspace
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),
                  numButton(0),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (enteredPin.isNotEmpty) {
                          enteredPin =
                              enteredPin.substring(0, enteredPin.length - 1);
                        }
                      });
                    },
                    child: const Column(
                      children: [
                        SizedBox(height: 40),
                        Icon(
                          Icons.backspace,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tombol reset
            TextButton(
              onPressed: () {
                setState(() {
                  enteredPin = '';
                  isPinWrong = false;
                });
              },
              child: const Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Reset',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
