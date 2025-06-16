import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:projek_pab_duit/widgets/period_filter_widget.dart';
import 'package:projek_pab_duit/widgets/total_expense_widget.dart';
import 'package:projek_pab_duit/widgets/income_expense_toggle_widget.dart';
import 'package:projek_pab_duit/widgets/statistics_chart_widget.dart';
import 'package:projek_pab_duit/db/database_helper.dart'; // Sesuaikan dengan path database helper Anda
import 'package:intl/intl.dart';

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

  List<FlSpot> _chartSpots = [];
  List<String> _chartTitles = [];
  String _totalAmount = "Rp0";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi untuk memuat data dari database
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allTransaksi = await DatabaseHelper.instance.getAllTransaksiAsMap();
      _processData(allTransaksi);
    } catch (e) {
      print('Error loading data: $e');
      // Fallback ke data dummy jika terjadi error
      _setDummyData();
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Fungsi untuk memproses data transaksi
  void _processData(List<Map<String, dynamic>> transaksiData) {
    // Filter berdasarkan tipe (Income/Expense)
    final filteredData = transaksiData.where((transaksi) {
      final kategoriTipe = transaksi['kategori_tipe']?.toString().toLowerCase();
      if (_selectedType == StatType.Income) {
        return kategoriTipe == 'income' || kategoriTipe == 'pemasukan';
      } else {
        return kategoriTipe == 'expense' || kategoriTipe == 'pengeluaran';
      }
    }).toList();

    // Hitung total amount
    double total = 0;
    for (var transaksi in filteredData) {
      total += (transaksi['jumlah'] as num?)?.toDouble() ?? 0;
    }
    _totalAmount = _formatCurrency(total);

    // Generate chart data berdasarkan periode
    switch (_selectedPeriod) {
      case StatPeriod.Daily:
        _generateDailyChart(filteredData);
        break;
      case StatPeriod.Monthly:
        _generateMonthlyChart(filteredData);
        break;
      case StatPeriod.Yearly:
        _generateYearlyChart(filteredData);
        break;
    }
  }

  // Generate chart untuk periode harian (30 hari terakhir)
  void _generateDailyChart(List<Map<String, dynamic>> data) {
    final now = DateTime.now();
    final spots = <FlSpot>[];
    final titles = <String>[];

    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: 29 - i));
      final dayData = data.where((transaksi) {
        final transaksiDate = DateTime.parse(transaksi['tanggal']);
        return transaksiDate.year == date.year &&
               transaksiDate.month == date.month &&
               transaksiDate.day == date.day;
      }).toList();

      double dayTotal = 0;
      for (var transaksi in dayData) {
        dayTotal += (transaksi['jumlah'] as num?)?.toDouble() ?? 0;
      }

      spots.add(FlSpot(i.toDouble(), dayTotal / 1000)); // Dalam ribuan
      
      // Tampilkan label setiap 5 hari
      if (i % 5 == 0) {
        titles.add(DateFormat('d/M').format(date));
      } else {
        titles.add('');
      }
    }

    _chartSpots = spots;
    _chartTitles = titles;
  }

  // Generate chart untuk periode bulanan (12 bulan terakhir)
  void _generateMonthlyChart(List<Map<String, dynamic>> data) {
    final now = DateTime.now();
    final spots = <FlSpot>[];
    final titles = <String>[''];

    for (int i = 0; i < 12; i++) {
      final month = DateTime(now.year, now.month - (11 - i));
      final monthData = data.where((transaksi) {
        final transaksiDate = DateTime.parse(transaksi['tanggal']);
        return transaksiDate.year == month.year &&
               transaksiDate.month == month.month;
      }).toList();

      double monthTotal = 0;
      for (var transaksi in monthData) {
        monthTotal += (transaksi['jumlah'] as num?)?.toDouble() ?? 0;
      }

      spots.add(FlSpot((i + 1).toDouble(), monthTotal / 1000000)); // Dalam jutaan
      titles.add(DateFormat('MMM').format(month));
    }

    titles.add('');
    _chartSpots = spots;
    _chartTitles = titles;
  }

  // Generate chart untuk periode tahunan (5 tahun terakhir)
  void _generateYearlyChart(List<Map<String, dynamic>> data) {
    final now = DateTime.now();
    final spots = <FlSpot>[];
    final titles = <String>[''];

    for (int i = 0; i < 5; i++) {
      final year = now.year - (4 - i);
      final yearData = data.where((transaksi) {
        final transaksiDate = DateTime.parse(transaksi['tanggal']);
        return transaksiDate.year == year;
      }).toList();

      double yearTotal = 0;
      for (var transaksi in yearData) {
        yearTotal += (transaksi['jumlah'] as num?)?.toDouble() ?? 0;
      }

      spots.add(FlSpot((i + 1).toDouble(), yearTotal / 1000000)); // Dalam jutaan
      titles.add(year.toString());
    }

    titles.add('');
    _chartSpots = spots;
    _chartTitles = titles;
  }

  // Fallback data dummy
  void _setDummyData() {
    _chartSpots = const [
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

    _chartTitles = [
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

    _totalAmount = "Rp14,869,675";
  }

  // Format currency
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  void _onPeriodChanged(StatPeriod period) {
    setState(() {
      _selectedPeriod = period;
    });
    _loadData(); // Reload data ketika period berubah
  }

  void _onTypeChanged(StatType type) {
    setState(() {
      _selectedType = type;
    });
    _loadData(); // Reload data ketika type berubah
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
            TotalExpenseWidget(totalAmount: _totalAmount),
            const SizedBox(height: 24),
            IncomeExpenseToggleWidget(
              selectedType: _selectedType,
              onTypeChanged: _onTypeChanged,
            ),
            const SizedBox(height: 35),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : StatisticsChartWidget(
                      spots: _chartSpots,
                      titles: _chartTitles,
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