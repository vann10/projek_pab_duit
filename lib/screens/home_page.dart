import 'package:flutter/material.dart';
import 'package:projek_pab_duit/db/database_helper.dart';
import 'package:projek_pab_duit/screens/balance_page.dart';
import 'package:projek_pab_duit/screens/detail_transaction.dart';
import 'package:projek_pab_duit/screens/insight_page.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:projek_pab_duit/widgets/add_button.dart';
import 'package:projek_pab_duit/widgets/balance.dart';
import 'package:projek_pab_duit/widgets/bottom_navbar.dart';
import 'package:projek_pab_duit/widgets/header.dart';
import 'package:projek_pab_duit/widgets/transaction_card.dart';
import 'package:projek_pab_duit/screens/profile_page.dart';

class Transaksi {
  final int id;
  final String deskripsi;
  final int jumlah;
  final String tipe;
  final String tanggal;
  final String? kategoriNama;
  final String? kategoriTipe;
  final String? dompetNama;

  Transaksi({
    required this.id,
    required this.deskripsi,
    required this.jumlah,
    required this.tipe,
    required this.tanggal,
    this.kategoriNama,
    this.kategoriTipe,
    this.dompetNama,
  });

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      deskripsi: map['deskripsi'] ?? '-',
      jumlah: (map['jumlah'] as num).toInt(),
      tipe: map['tipe'] ?? '',
      tanggal: map['tanggal'] ?? '',
      kategoriNama: map['kategori_nama'],
      kategoriTipe: map['kategori_tipe'],
      dompetNama: map['dompet_nama'],
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const WalletScreen(),
    const InsightPage(),
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      drawer: const AppDrawer(),
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

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Transaksi> transaksiList = [];

  @override
  void initState() {
    super.initState();
    fetchTransaksi();
  }

  Future<void> fetchTransaksi() async {
    final data = await DatabaseHelper.instance.getAllTransaksiList();
    setState(() {
      transaksiList = data;
    });
  }

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
                colors: [DarkColors.bg, DarkColors.bg1, DarkColors.bg],
                stops: [0.0, 0.5, 1],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -170,
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
              const Padding(
                padding: EdgeInsets.only(left: 25),
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
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: transaksiList.length,
                  itemBuilder: (context, index) {
                    final tx = transaksiList[index];
                    final formattedDate =
                        DateTime.tryParse(tx.tanggal) != null
                            ? '${DateTime.parse(tx.tanggal).day}/${DateTime.parse(tx.tanggal).month}/${DateTime.parse(tx.tanggal).year}'
                            : tx.tanggal;
                    return TransactionCard(
                      merchantName: tx.kategoriNama ?? '',
                      date: formattedDate,
                      deskripsi: tx.deskripsi,
                      amount: tx.jumlah,
                      logoAsset: 'assets/images/shell_logo.png',
                      tipe: tx.tipe,
                      onTap: () {
                        // Pass transaction data to detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailTransactionPage(
                              transactionData: {
                                'id': tx.id,
                                'tanggal': tx.tanggal,
                                'jumlah': tx.jumlah,
                                'deskripsi': tx.deskripsi,
                                'tipe': tx.tipe,
                                'kategori_nama': tx.kategoriNama,
                                'kategori_tipe': tx.kategoriTipe,
                                'dompet_nama': tx.dompetNama,
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          AddButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
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
              'Kelompok 1',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: const Text(
              'Kelompok1@gmail.com',
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
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
  return const Center(child: Text("WalletPage"));
}

Widget statsPage() {
  return const Center(child: Text("StatsPage"));
}

Widget profilePage() {
  return const Center(child: Text("ProfilePage"));
}
