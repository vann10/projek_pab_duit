import 'package:flutter/material.dart';
import 'package:projek_pab_duit/screens/saving_plan_page.dart';
import 'package:projek_pab_duit/screens/statistic_page.dart';
import 'package:projek_pab_duit/themes/colors.dart';

class InsightPage extends StatelessWidget {
  const InsightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: DarkColors.bg,
        appBar: AppBar(
          backgroundColor: DarkColors.bg,
          elevation: 0,
          toolbarHeight: 80,
          leading: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Muncul menu about?
            },
          ),
          title: const Text(
            'Insight',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: DarkColors.oren,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [Tab(text: 'Statistics'), Tab(text: 'Savings plan')],
          ),
        ),
        // Panggil widget dari file terpisah di sini
        body: const TabBarView(children: [StatisticsView(), SavingsPlanView()]),
      ),
    );
  }
}
