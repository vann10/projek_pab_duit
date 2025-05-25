import 'package:flutter/material.dart';
import 'package:projek_pab_duit/home_page.dart';
import 'package:projek_pab_duit/loading_page.dart';
import 'package:projek_pab_duit/login.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dukun Cuaca',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {'/': (context) => const Login()},
    );
  }
}
