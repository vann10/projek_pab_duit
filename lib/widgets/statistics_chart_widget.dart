import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:projek_pab_duit/screens/statistic_page.dart';

class StatisticsChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> titles;
  final StatPeriod selectedPeriod;
  final StatType selectedType;

  const StatisticsChartWidget({
    super.key,
    required this.spots,
    required this.titles,
    required this.selectedPeriod,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LineChart(
          LineChartData(
            minX: 0,
            maxX: 13,
            minY: 0,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingVerticalLine: (value) {
                return const FlLine(color: Color(0x22FFFFFF), strokeWidth: 1);
              },
              drawHorizontalLine: false,
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  interval: 1,
                  getTitlesWidget:
                      (value, meta) => _buildBottomTitle(value, meta),
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: _buildLineTouchData(),
            lineBarsData: [_buildLineChartBarData()],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    // Kondisi untuk memastikan hanya menggambar di titik bilangan bulat
    if (value != value.roundToDouble()) {
      return const SizedBox();
    }

    // Guard clause untuk memastikan indeks tidak di luar jangkauan
    if (value.toInt() >= titles.length || value.toInt() < 0) {
      return const SizedBox();
    }

    final isHighlighted = value.toInt() == 8; // bulan yang di-highlight
    return SideTitleWidget(
      meta: meta,
      space: 10,
      angle: 5.5, // rotasi nama bulan
      child: Text(
        titles[value.toInt()],
        style: TextStyle(
          color: isHighlighted ? const Color(0xFF00E5FF) : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => Colors.white,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            return null; // Disable tooltip
          }).toList();
        },
      ),
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((spotIndex) {
          return TouchedSpotIndicatorData(
            const FlLine(color: Colors.red), // Garis penghubung ke bawah
            FlDotData(
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: DarkColors.expenseFont,
                  strokeWidth: 1,
                  strokeColor: const Color(0xFF00E5FF),
                );
              },
            ),
          );
        }).toList();
      },
    );
  }

  LineChartBarData _buildLineChartBarData() {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      barWidth: 1,
      color: const Color(0xFF00E5FF),
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00A6C2).withOpacity(0.9),
            const Color(0xFF201F3C).withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
