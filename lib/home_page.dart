import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_pab_duit/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    Center(child: Text("Wallet", style: TextStyle(color: Colors.white))),
    Center(child: Text("Stats", style: TextStyle(color: Colors.white))),
    Center(child: Text("Profile", style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Builder(builder: (context) => Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(center: Alignment(-1.0, -1.5),
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
          Column(
            children: [
              Header(context),
              const SizedBox(height: 50),
              Balance(),
              ],
              ),
            ],
          ),
        ),
      );
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         // Background image
  //         Container(
  //           width: double.infinity,
  //           height: double.infinity,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               gradient: RadialGradient(
  //                 center: Alignment(-1.0, -1.5),
  //                 radius: 1,
  //                 colors: [
  //                   Color(0xFF141326),
  //                   Color.fromARGB(255, 64, 134, 232),
  //                   Color(0xFF141326),
  //                 ],
  //                 stops: [0.0, 0.7, 1],
  //               ),
  //             ),
  //           ),
  //         ),

  //         Column(children: [
  //           Header(),
  //           SizedBox(height: 50),
  //           Balance()
  //           ]
  //           ),
  //       ],
  //     ),
  //   );
  // }

Widget Header(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 80.0,
      left: 20.0,
    ),
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
        const SizedBox(width: 80),
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

Widget Balance() {
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
        SizedBox(height: 70),
        Image.asset('assets/images/percentage.png', width: 350),
      ],
    ),
  );
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF1A1A2E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF0F3460),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: const Text('Beranda', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: const Text('Pengaturan', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
