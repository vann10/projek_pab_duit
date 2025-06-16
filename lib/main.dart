import 'package:flutter/material.dart';
import 'package:projek_pab_duit/screens/add_pemasukan.dart';
import 'package:projek_pab_duit/screens/wallet_page.dart';
import 'package:projek_pab_duit/screens/detail_transaction.dart';
import 'package:projek_pab_duit/screens/home_page.dart' as home;
import 'package:projek_pab_duit/screens/loading_page.dart';
import 'package:projek_pab_duit/screens/login.dart';
import 'package:projek_pab_duit/db/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi database
  final db = await DatabaseHelper.instance.database;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOMPET\'Q',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingPage(),
        '/login': (context) => Login(),
        '/home': (context) => const home.HomePage(),
        '/add': (context) => AddPemasukanPage(),
        '/balance': (context) => WalletScreen(),
        '/detail': (context) => DetailTransactionPage(),
      },
    );
  }
}
