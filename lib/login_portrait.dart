// login_portrait.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'blocs/login_bloc.dart';

class LoginPortrait extends StatelessWidget {
  const LoginPortrait({super.key});

  Widget numButton(BuildContext context, int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextButton(
        onPressed: () {
          context.read<LoginBloc>().add(DigitPressed(number));
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
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Text(
                      state.isPinWrong ? "PIN Salah" : "Masukkan PIN Anda",
                      style: GoogleFonts.dmSans(
                        color: state.isPinWrong ? Colors.red : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: state.isPinVisible ? 16 : 50),
                  ],
                );
              },
            ),

            // Kotak PIN
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      margin: EdgeInsets.only(left: 23, right: 23, top: 10),
                      width: state.isPinVisible ? 50 : 16,
                      height: state.isPinVisible ? 50 : 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color:
                            index < state.enteredPin.length
                                ? state.isPinVisible
                                    ? const Color.fromARGB(255, 0, 106, 255)
                                    : CupertinoColors.activeBlue
                                : CupertinoColors.activeBlue.withOpacity(0.1),
                      ),
                      child:
                          state.isPinVisible && index < state.enteredPin.length
                              ? Center(
                                child: Text(
                                  state.enteredPin[index],
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
                );
              },
            ),

            const SizedBox(height: 50),

            // Tombol toggle PIN terlihat/sembunyi
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Container(
                  margin: EdgeInsets.all(20),
                  child: IconButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(TogglePinVisibility());
                    },
                    icon: Icon(
                      state.isPinVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Tombol angka 1-9
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => numButton(context, 1 + 3 * i + index),
                  ),
                ),
              ),

            // Tombol 0 dan backspace
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),
                  numButton(context, 0),
                  TextButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(BackspacePressed());
                    },
                    child: const Column(
                      children: [
                        SizedBox(height: 40),
                        Icon(Icons.backspace, color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tombol reset
            TextButton(
              onPressed: () {
                context.read<LoginBloc>().add(ResetPin());
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
