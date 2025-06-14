import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projek_pab_duit/themes/colors.dart'; // Sesuaikan path jika perlu

// Enum untuk mengelola state filter periode dan tipe
enum StatPeriod { Daily, Monthly, Yearly }

enum StatType { Income, Expense }

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  StatPeriod _selectedPeriod = StatPeriod.Monthly;
  StatType _selectedType = StatType.Expense;

  // Data dummy untuk chart
  final List<FlSpot> _monthlySpots = const [
    FlSpot(0, 5),
    FlSpot(1, 2.5),
    FlSpot(2, 4.0),
    FlSpot(3, 3.5),
    FlSpot(4, 5.0),
    FlSpot(5, 3.2),
    FlSpot(6, 6.0),
    FlSpot(7, 5.5),
    FlSpot(8, 7.0),
    FlSpot(9, 6.5),
    FlSpot(10, 4.0),
    FlSpot(11, 5.5),
    FlSpot(12, 6.2),
    FlSpot(13, 5),
  ];

  // Judul untuk sumbu X pada chart
  final List<String> _monthlyTitles = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
    '',
  ];

  final Map<StatPeriod, BoxDecoration> _selectedFilterDecoration = {
    StatPeriod.Daily: BoxDecoration(
      color: DarkColors.daily,
      borderRadius: BorderRadius.circular(10),
    ),
    StatPeriod.Monthly: BoxDecoration(
      color: DarkColors.monthly,
      borderRadius: BorderRadius.circular(10),
    ),
    StatPeriod.Yearly: BoxDecoration(
      color: DarkColors.yearly,
      borderRadius: BorderRadius.circular(10),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 24),
      child: Column(
        children: [
          _buildPeriodFilters(),
          const SizedBox(height: 30),
          _buildTotalExpense(),
          const SizedBox(height: 24),
          _buildIncomeExpenseToggle(),
          const SizedBox(height: 35),
          Expanded(child: _buildChart()),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildPeriodFilters() {
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
    final bool isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = period;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: isSelected ? _selectedFilterDecoration[period] : null,
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

  Widget _buildTotalExpense() {
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

  Widget _buildIncomeExpenseToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTypeToggle("Income", StatType.Income),
        _buildTypeToggle("Expense", StatType.Expense),
      ],
    );
  }

  Widget _buildTypeToggle(String label, StatType type) {
    final bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
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
            color:
                isSelected
                    ? Color(0xFF00E5FF)
                    : Colors.transparent, // Cyan color for underline
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
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
                  getTitlesWidget: (value, meta) {
                    // Kondisi untuk memastikan hanya menggambar di titik bilangan bulat
                    if (value != value.roundToDouble()) {
                      return const SizedBox();
                    }

                    // Guard clause untuk memastikan indeks tidak di luar jangkauan
                    if (value.toInt() >= _monthlyTitles.length ||
                        value.toInt() < 0) {
                      return const SizedBox();
                    }

                    final isHighlighted = value.toInt() == 0; //September
                    return SideTitleWidget(
                      meta: meta,
                      space: 10,
                      angle: 1,
                      child: Text(
                        _monthlyTitles[value.toInt()],
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
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.white,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return null; // Disable default tooltip
                  }).toList();
                },
              ),
              getTouchedSpotIndicator: (barData, spotIndexes) {
                return spotIndexes.map((spotIndex) {
                  // The indicator for the touched point
                  return TouchedSpotIndicatorData(
                    const FlLine(color: Colors.transparent), // Hide line
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
                spots: _monthlySpots,
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
        SizedBox(height: 80),
      ],
    );
  }
}
