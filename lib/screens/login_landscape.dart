// login_landscape.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/login_bloc.dart';

class LoginLandscape extends StatelessWidget {
  const LoginLandscape({super.key});

  Widget numButton(BuildContext context, int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 500;

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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: isSmallScreen ? 8.0 : 16.0,
            ),
            child: Row(
              children: [
                // Left side - PIN display and visibility toggle
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Pesan judul PIN
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return Text(
                            state.isPinWrong
                                ? "PIN Salah"
                                : "Masukkan PIN Anda",
                            style: GoogleFonts.dmSans(
                              color:
                                  state.isPinWrong ? Colors.red : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      // Kotak PIN
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                width: state.isPinVisible ? 40 : 12,
                                height: state.isPinVisible ? 40 : 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color:
                                      index < state.enteredPin.length
                                          ? state.isPinVisible
                                              ? const Color.fromARGB(
                                                255,
                                                0,
                                                106,
                                                255,
                                              )
                                              : CupertinoColors.activeBlue
                                          : CupertinoColors.activeBlue
                                              .withOpacity(0.1),
                                ),
                                child:
                                    state.isPinVisible &&
                                            index < state.enteredPin.length
                                        ? Center(
                                          child: Text(
                                            state.enteredPin[index],
                                            style: const TextStyle(
                                              fontSize: 15,
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

                      const SizedBox(height: 30),

                      // Tombol toggle PIN terlihat/sembunyi
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return IconButton(
                            onPressed: () {
                              context.read<LoginBloc>().add(
                                TogglePinVisibility(),
                              );
                            },
                            icon: Icon(
                              state.isPinVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Right side - Number pad
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tombol angka 1-9
                      for (var i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
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
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 50),
                            numButton(context, 0),
                            TextButton(
                              onPressed: () {
                                context.read<LoginBloc>().add(
                                  BackspacePressed(),
                                );
                              },
                              child: const Column(
                                children: [
                                  SizedBox(height: 30),
                                  Icon(
                                    Icons.backspace,
                                    color: Colors.white,
                                    size: 20,
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
                          context.read<LoginBloc>().add(ResetPin());
                        },
                        child: const Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
