import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_pab_duit/bottom_navbar.dart';
import 'package:projek_pab_duit/transaction_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    WalletPage(),
    StatsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141326),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          // Background image
          Positioned(
            left: 0,
            right: 0,
            bottom: -190,
            child: Image.asset(
              'assets/images/subtract.png',
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(context),
              const SizedBox(height: 50),

              balance(),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  "My Transactions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      TransactionCard(
                        merchantName: 'Shell',
                        date: 'Sep 02, 2022',
                        amount: 45,
                        logoAsset: 'assets/images/shell_logo.png',
                      ),
                      TransactionCard(
                        merchantName: 'Shell',
                        date: 'Sep 02, 2022',
                        amount: 45,
                        logoAsset: 'assets/images/shell_logo.png',
                      ),
                      TransactionCard(
                        merchantName: 'Shell',
                        date: 'Sep 02, 2022',
                        amount: 45,
                        logoAsset: 'assets/images/shell_logo.png',
                      ),
                      TransactionCard(
                        merchantName: 'Shell',
                        date: 'Sep 02, 2022',
                        amount: 45,
                        logoAsset: 'assets/images/shell_logo.png',
                      ),
                      TransactionCard(
                        merchantName: 'Shell',
                        date: 'Sep 02, 2022',
                        amount: 45,
                        logoAsset: 'assets/images/shell_logo.png',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget header(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 80.0, left: 20.0),
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
        SizedBox(width: 80),
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

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A2E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white54),
            accountName: const Text('Pleeerrr'),
            accountEmail: null,
            currentAccountPicture: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset('assets/images/team.jpg'),
                  ),
                ),
              ),
            ),
            otherAccountsPictures: const [
              Icon(Icons.edit, color: Colors.white),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.home),
            iconColor: Colors.white,
            title: const Text('Beranda', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            iconColor: Colors.white,
            title: const Text(
              'Pengaturan',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

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
        SizedBox(height: 70),
        Image.asset('assets/images/percentage.png', width: 360),
      ],
    ),
  );
}

Widget WalletPage() {
  return Center(child: Text("KON"));
}

Widget StatsPage() {
  return Center(child: Text("WalletPage"));
}

Widget ProfilePage() {
  return Center(child: Text("WalletPage"));
}
