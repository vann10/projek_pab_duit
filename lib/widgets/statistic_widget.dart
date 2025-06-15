import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projek_pab_duit/screens/statistic_page.dart';
import 'package:projek_pab_duit/themes/colors.dart';

/// WIDGET 1: FILTER PERIODE (DAILY, MONTHLY, YEARLY)
class PeriodFilters extends StatelessWidget {
  final StatPeriod selectedPeriod;
  final Map<StatPeriod, BoxDecoration> selectedFilterDecoration;
  final ValueChanged<StatPeriod> onPeriodSelected;

  const PeriodFilters({
    super.key,
    required this.selectedPeriod,
    required this.selectedFilterDecoration,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF201F3C),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildFilterChip("Daily", StatPeriod.Daily),
          _buildFilterChip("Monthly", StatPeriod.Monthly),
          _buildFilterChip("Yearly", StatPeriod.Yearly),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, StatPeriod period) {
    final bool isSelected = selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => onPeriodSelected(period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: isSelected ? selectedFilterDecoration[period] : null,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// WIDGET 2: TOTAL EXPENSE
class TotalExpenseDisplay extends StatelessWidget {
  const TotalExpenseDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Total Expense',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                children: [TextSpan(text: "Rp14,869,675")],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// WIDGET 3: TOGGLE INCOME / EXPENSE
class IncomeExpenseToggle extends StatelessWidget {
  final StatType selectedType;
  final ValueChanged<StatType> onTypeSelected;

  const IncomeExpenseToggle({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTypeToggle("Income", StatType.Income),
        _buildTypeToggle("Expense", StatType.Expense),
      ],
    );
  }

  Widget _buildTypeToggle(String label, StatType type) {
    final bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () => onTypeSelected(type),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 80,
            color: isSelected ? const Color(0xFF00E5FF) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

/// WIDGET 4: GRAFIK STATISTIK
class StatisticsChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> bottomTitles;

  const StatisticsChart({
    super.key,
    required this.spots,
    required this.bottomTitles,
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
              getDrawingVerticalLine:
                  (value) =>
                      const FlLine(color: Color(0x22FFFFFF), strokeWidth: 1),
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
                  getTitlesWidget: (value, meta) {
                    if (value != value.roundToDouble()) return const SizedBox();
                    if (value.toInt() >= bottomTitles.length ||
                        value.toInt() < 0) {
                      return const SizedBox();
                    }

                    final isHighlighted = value.toInt() == 0;
                    return SideTitleWidget(
                      meta: meta,
                      space: 10,
                      angle: 1,
                      child: Text(
                        bottomTitles[value.toInt()],
                        style: TextStyle(
                          color:
                              isHighlighted
                                  ? const Color(0xFF00E5FF)
                                  : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.white,
                getTooltipItems:
                    (touchedSpots) => touchedSpots.map((spot) => null).toList(),
              ),
              getTouchedSpotIndicator: (barData, spotIndexes) {
                return spotIndexes.map((spotIndex) {
                  return TouchedSpotIndicatorData(
                    const FlLine(color: Colors.white30),
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
            ),
            lineBarsData: [
              LineChartBarData(
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
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
