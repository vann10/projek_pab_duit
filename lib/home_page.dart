import 'package:flutter/material.dart';
import 'package:projek_pab_duit/bottom_navbar.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:projek_pab_duit/transaction_card.dart';
import 'package:projek_pab_duit/widgets/balance.dart';
import 'package:projek_pab_duit/widgets/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    walletPage(),
    statsPage(),
    profilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
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
    final List<dynamic> transactionList = [
      TransactionCard(
        merchantName: 'Shell',
        date: 'Sep 02, 2022',
        amount: 45.0,
        logoAsset: 'assets/images/shell_logo.png',
      ),
      TransactionCard(
        merchantName: 'Shell',
        date: 'Sep 02, 2022',
        amount: 45.0,
        logoAsset: 'assets/images/shell_logo.png',
      ),
      TransactionCard(
        merchantName: 'Shell',
        date: 'Sep 02, 2022',
        amount: 45.0,
        logoAsset: 'assets/images/shell_logo.png',
      ),
      TransactionCard(
        merchantName: 'Shell',
        date: 'Sep 02, 2022',
        amount: 45.0,
        logoAsset: 'assets/images/shell_logo.png',
      ),
      TransactionCard(
        merchantName: 'Shell',
        date: 'Sep 02, 2022',
        amount: 45.0,
        logoAsset: 'assets/images/shell_logo.png',
      ),
    ];

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
                colors: [DarkColors.bg, DarkColors.bg1, DarkColors.bg],
                stops: [0.0, 0.5, 1],
              ),
            ),
          ),
          // Background image
          Positioned(
            left: 0,
            right: 0,
            bottom: -160,
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
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 100),
                  itemCount: transactionList.length,
                  itemBuilder: (context, index) {
                    final tx = transactionList[index];
                    return TransactionCard(
                      merchantName: tx.merchantName,
                      date: tx.date,
                      amount: tx.amount,
                      logoAsset: tx.logoAsset,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: DarkColors.bg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: SweepGradient(
                center: Alignment(-1.0, -1.5),
                colors: [DarkColors.bg, DarkColors.bg1, DarkColors.bg],
                stops: [0.0, 0.6, 0.8],
              ),
            ),

            accountName: const Text(
              'Pleeerrr',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              'Kelompok1@gmail.com',
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DarkColors.oren,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ClipOval(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset('assets/images/team.jpg'),
                  ),
                ),
              ),
            ),
            otherAccountsPictures: const [
              Icon(Icons.edit, color: DarkColors.oren),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.home),
            iconColor: DarkColors.oren,
            title: const Text(
              'Beranda',
              style: TextStyle(color: DarkColors.oren),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            iconColor: DarkColors.oren,
            title: const Text(
              'Pengaturan',
              style: TextStyle(color: DarkColors.oren),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

Widget walletPage() {
  return Center(child: Text("KON"));
}

Widget statsPage() {
  return Center(child: Text("WalletPage"));
}

Widget profilePage() {
  return Center(child: Text("WalletPage"));
}
