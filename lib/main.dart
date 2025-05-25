import 'package:flutter/material.dart';
import 'package:projek_pab_duit/home_page.dart';
import 'package:projek_pab_duit/loading_page.dart';

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
<<<<<<< HEAD
<<<<<<< HEAD
      routes: {'/': (context) => const HomePage()},
=======
      routes: {'/': (context) => const Login()},
>>>>>>> parent of 5b28002 (Merge branch 'main' of https://github.com/vann10/projek_pab_duit)
=======
      routes: {'/': (context) => const Login()},
>>>>>>> parent of 5b28002 (Merge branch 'main' of https://github.com/vann10/projek_pab_duit)
    );
  }
}
