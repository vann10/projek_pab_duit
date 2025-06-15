import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:projek_pab_duit/widgets/period_filter_widget.dart';
import 'package:projek_pab_duit/widgets/total_expense_widget.dart';
import 'package:projek_pab_duit/widgets/income_expense_toggle_widget.dart';
import 'package:projek_pab_duit/widgets/statistics_chart_widget.dart';

// Enum untuk mengelola state filter periode dan tipe
enum StatPeriod { Daily, Monthly, Yearly }

enum StatType { Income, Expense }

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
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

  void _onPeriodChanged(StatPeriod period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  void _onTypeChanged(StatType type) {
    setState(() {
      _selectedType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            PeriodFilterWidget(
              selectedPeriod: _selectedPeriod,
              onPeriodChanged: _onPeriodChanged,
            ),
            const SizedBox(height: 30),
            const TotalExpenseWidget(totalAmount: "Rp14,869,675"),
            const SizedBox(height: 24),
            IncomeExpenseToggleWidget(
              selectedType: _selectedType,
              onTypeChanged: _onTypeChanged,
            ),
            const SizedBox(height: 35),
            Expanded(
              child: StatisticsChartWidget(
                spots: _monthlySpots,
                titles: _monthlyTitles,
                selectedPeriod: _selectedPeriod,
                selectedType: _selectedType,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
