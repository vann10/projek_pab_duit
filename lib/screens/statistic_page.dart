import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:projek_pab_duit/widgets/period_filter_widget.dart';
import 'package:projek_pab_duit/widgets/total_expense_widget.dart';
import 'package:projek_pab_duit/widgets/income_expense_toggle_widget.dart';
import 'package:projek_pab_duit/db/database_helper.dart';
import 'package:intl/intl.dart';

// Enum untuk mengelola state filter periode dan tipe
enum StatPeriod { Daily, Monthly, Yearly }

enum StatType { Income, Expense }

// Model untuk kategori, agar mudah mengakses ikon dan warna
class CategoryItem {
  final int id;
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  StatPeriod _selectedPeriod = StatPeriod.Monthly;
  StatType _selectedType = StatType.Expense;
  int _touchedIndex = -1;

  // State untuk data yang sudah diproses, bukan widget
  Map<String, double> _categoryTotals = {};
  double _totalAmount = 0.0;
  bool _isLoading = true;

  // Mendefinisikan kategori untuk expense dan income
  static final List<CategoryItem> _categoriesExpense = [
    CategoryItem(
      id: 1,
      name: 'Makanan',
      icon: Icons.fastfood,
      color: Colors.orange,
    ),
    CategoryItem(
      id: 2,
      name: 'Kebutuhan',
      icon: Icons.shopping_cart,
      color: Colors.cyan,
    ),
    CategoryItem(
      id: 3,
      name: 'Pakaian',
      icon: Icons.checkroom,
      color: Colors.purple,
    ),
    CategoryItem(
      id: 4,
      name: 'Tabungan',
      icon: Icons.bar_chart,
      color: Colors.amber,
    ),
    CategoryItem(
      id: 5,
      name: 'Sosial',
      icon: Icons.people,
      color: Colors.green,
    ),
    CategoryItem(
      id: 6,
      name: 'Transportasi',
      icon: Icons.directions_bus,
      color: Colors.red,
    ),
    CategoryItem(
      id: 7,
      name: 'Lainnya',
      icon: Icons.more_horiz,
      color: Colors.grey,
    ),
  ];

  static final List<CategoryItem> _categoriesIncome = [
    CategoryItem(id: 8, name: 'Gaji', icon: Icons.paid, color: Colors.green),
    CategoryItem(id: 9, name: 'Bonus', icon: Icons.redeem, color: Colors.cyan),
    CategoryItem(
      id: 10,
      name: 'Uang Saku',
      icon: Icons.payment,
      color: Colors.orange,
    ),
    CategoryItem(
      id: 11,
      name: 'Lainnya',
      icon: Icons.more_horiz,
      color: Colors.grey,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final allTransaksi = await DatabaseHelper.instance.getAllTransaksiAsMap();
      if (mounted) {
        _processData(allTransaksi);
      }
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) {
        setState(() {
          _categoryTotals = {};
          _totalAmount = 0;
          _isLoading = false;
        });
      }
    }
  }

  // Fungsi ini sekarang HANYA memproses data, tidak membuat widget
  void _processData(List<Map<String, dynamic>> transaksiData) {
    // 1. Filter data berdasarkan tipe (Income/Expense)
    final typeString = _selectedType == StatType.Expense ? 'expense' : 'income';
    final filteredByType =
        transaksiData.where((tx) {
          final kategoriTipe =
              tx['kategori_tipe']?.toString().toLowerCase() ?? '';
          return kategoriTipe == typeString;
        }).toList();

    // 2. Filter data berdasarkan periode
    final now = DateTime.now();
    final filteredByDate =
        filteredByType.where((tx) {
          final txDateString = tx['tanggal'];
          if (txDateString == null) return false;
          final txDate = DateTime.parse(txDateString);

          switch (_selectedPeriod) {
            case StatPeriod.Daily:
              return txDate.isAfter(now.subtract(const Duration(days: 30)));
            case StatPeriod.Monthly:
              return txDate.year == now.year && txDate.month == now.month;
            case StatPeriod.Yearly:
              return txDate.year == now.year;
          }
        }).toList();

    // 3. Agregasi data: kelompokkan berdasarkan kategori dan hitung totalnya
    final Map<String, double> categoryTotals = {};
    double grandTotal = 0;
    for (var tx in filteredByDate) {
      final category = tx['kategori_nama'] as String? ?? 'Lainnya';
      final amount = (tx['jumlah'] as num?)?.toDouble() ?? 0.0;
      categoryTotals[category] = (categoryTotals[category] ?? 0.0) + amount;
      grandTotal += amount;
    }

    // 4. Update state dengan data yang sudah diolah
    if (mounted) {
      setState(() {
        _categoryTotals = categoryTotals;
        _totalAmount = grandTotal;
        _isLoading = false;
      });
    }
  }

  Widget _buildBadge(String name, double value, IconData icon, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                _formatCurrency(value),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  CategoryItem _getCategoryItem(String name) {
    final list =
        _selectedType == StatType.Expense
            ? _categoriesExpense
            : _categoriesIncome;
    return list.firstWhere(
      (item) => item.name == name,
      orElse:
          () => CategoryItem(
            id: 0,
            name: 'Lainnya',
            icon: Icons.category,
            color: Colors.grey,
          ),
    );
  }

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
      _touchedIndex = -1;
    });
    _loadData();
  }

  void _onTypeChanged(StatType type) {
    setState(() {
      _selectedType = type;
      _touchedIndex = -1;
    });
    _loadData();
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
            TotalExpenseWidget(
              totalAmount: _formatCurrency(_totalAmount),
              label:
                  'Total ${_selectedType == StatType.Expense ? "Expense" : "Income"}',
            ),
            const SizedBox(height: 24),
            IncomeExpenseToggleWidget(
              selectedType: _selectedType,
              onTypeChanged: _onTypeChanged,
            ),
            const SizedBox(height: 35),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _categoryTotals.isEmpty
                      ? const Center(
                        child: Text(
                          'Tidak ada data untuk periode ini.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                      : _buildPieChart(),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Fungsi ini sekarang membangun daftar PieChartSectionData secara dinamis
  Widget _buildPieChart() {
    final sortedCategories =
        _categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    List<PieChartSectionData> buildSections() {
      List<PieChartSectionData> sections = [];
      for (int i = 0; i < sortedCategories.length; i++) {
        final category = sortedCategories[i];
        final percentage =
            _totalAmount > 0 ? (category.value / _totalAmount) * 100 : 0.0;
        final isTouched = i == _touchedIndex;
        final fontSize = isTouched ? 18.0 : 12.0;
        final radius = isTouched ? 110.0 : 100.0;
        final itemInfo = _getCategoryItem(category.key);

        sections.add(
          PieChartSectionData(
            color: itemInfo.color,
            value: percentage,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
            ),
            badgeWidget:
                isTouched
                    ? _buildBadge(
                      itemInfo.name,
                      category.value,
                      itemInfo.icon,
                      itemInfo.color,
                    )
                    : null,
            badgePositionPercentageOffset: .50,
          ),
        );
      }
      return sections;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 60,
          sections: buildSections(),
        ),
      ),
    );
  }
}
