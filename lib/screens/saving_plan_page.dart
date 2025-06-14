import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projek_pab_duit/themes/colors.dart'; // Sesuaikan path jika perlu

class SavingsPlanView extends StatelessWidget {
  const SavingsPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data untuk mensimulasikan daftar yang panjang
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: _buildCurrentPlanCard(),
          ),

          // 2. BAGIAN YANG BISA DI-SCROLL
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(), // Efek pantul saat scroll
              itemCount: pastPlansData.length,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                final plan = pastPlansData[index];
                // Memanggil builder untuk setiap item dalam daftar
                return _buildPastPlanCard(
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

  Widget _buildCurrentPlanCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF201F3C),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current plan',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'May 25%',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(), // Mendorong ikon ke kanan
              // Ikon-ikon baru sesuai gambar
              const Icon(
                Icons.delete_outlined,
                color: Colors.white70,
                size: 22,
              ),
              const SizedBox(width: 12),
              const Icon(Icons.search, color: Colors.white70, size: 22),
              const SizedBox(width: 12),
              const Icon(Icons.edit_square, color: Colors.white70, size: 22),
            ],
          ),
          const SizedBox(height: 20),
          // Grafik
          SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3.5),
                      FlSpot(1, 3.8),
                      FlSpot(2, 3.0),
                      FlSpot(3, 3.2),
                      FlSpot(4, 2.8),
                      FlSpot(5, 3.1),
                      FlSpot(6, 2.5),
                    ],
                    isCurved: true,
                    color: Colors.yellow[600],
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          DarkColors.oren.withOpacity(0.5),
                          DarkColors.oren.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Today is May 17th and you spent: ₹324,64',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'You can spend:',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              '₹457,45',
              style: TextStyle(
                color: DarkColors.oren,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun setiap card pada daftar rencana lampau
  Widget _buildPastPlanCard({
    required String month,
    required int planPercentage,
    required String dateRange,
    required int amount,
    required Color avatarColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(0.8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.blueAccent, DarkColors.bg],
            begin: Alignment.centerLeft,
            stops: [0, 0.2, 0.9],
            end: Alignment.centerRight,
          ),
        ),
        child: Container(
          // 2. Ini adalah Container DALAM (konten asli Anda)
          // Properti 'border' dihapus dari sini
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(
              255,
              25,
              25,
              49,
            ), // Warna card yang lebih gelap
            borderRadius: BorderRadius.circular(16),
          ),
          // Letakkan child dari container Anda di sini
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: avatarColor,
                radius: 22,
                child: Text(
                  month,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan $planPercentage%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateRange,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Nominal dengan background container
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blueAccent.withAlpha(120),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  '₹$amount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
