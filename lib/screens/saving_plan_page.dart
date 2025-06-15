import 'package:flutter/material.dart';
import 'package:projek_pab_duit/widgets/saving_plan_card.dart';

class SavingsPlanView extends StatelessWidget {
  const SavingsPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data tetap di sini karena ini adalah data untuk halaman ini
    final List<Map<String, dynamic>> pastPlansData = [
      {
        'month': 'APR',
        'planPercentage': 15,
        'dateRange': 'Apr 1 - Apr 30, 2022',
        'amount': 2385,
        'avatarColor': Colors.purple.shade300,
      },
      {
        'month': 'MAR',
        'planPercentage': 10,
        'dateRange': 'Mar 1 - Mar 31, 2022',
        'amount': 1385,
        'avatarColor': Colors.amber.shade400,
      },
      {
        'month': 'FEB',
        'planPercentage': 25,
        'dateRange': 'Feb 1 - Feb 28, 2022',
        'amount': 3754,
        'avatarColor': Colors.lightBlue,
      },
      {
        'month': 'JAN',
        'planPercentage': 20,
        'dateRange': 'Jan 1 - Jan 31, 2022',
        'amount': 3100,
        'avatarColor': Colors.green,
      },
      {
        'month': 'DEC',
        'planPercentage': 18,
        'dateRange': 'Dec 1 - Dec 31, 2021',
        'amount': 2800,
        'avatarColor': Colors.redAccent,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // 1. BAGIAN STATIS (TIDAK BISA SCROLL)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            // Memanggil widget CurrentPlanCard yang sudah dipisah
            child: CurrentPlanCard(),
          ),

          // 2. BAGIAN YANG BISA DI-SCROLL
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: pastPlansData.length,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                final plan = pastPlansData[index];
                // Memanggil widget PastPlanCard yang sudah dipisah
                return PastPlanCard(
                  month: plan['month'],
                  planPercentage: plan['planPercentage'],
                  dateRange: plan['dateRange'],
                  amount: plan['amount'],
                  avatarColor: plan['avatarColor'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
