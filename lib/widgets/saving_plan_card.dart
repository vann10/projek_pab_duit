import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projek_pab_duit/themes/colors.dart';

/// WIDGET UNTUK CARD "CURRENT PLAN"
class CurrentPlanCard extends StatelessWidget {
  const CurrentPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Kode ini diambil dari fungsi _buildCurrentPlanCard
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
              'Rp457,425',
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
}

/// WIDGET UNTUK SETIAP ITEM PADA DAFTAR "PAST PLAN"
class PastPlanCard extends StatelessWidget {
  final String month;
  final int planPercentage;
  final String dateRange;
  final int amount;
  final Color avatarColor;

  const PastPlanCard({
    super.key,
    required this.month,
    required this.planPercentage,
    required this.dateRange,
    required this.amount,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    // Kode ini diambil dari fungsi _buildPastPlanCard
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 25, 25, 49),
            borderRadius: BorderRadius.circular(16),
          ),
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
