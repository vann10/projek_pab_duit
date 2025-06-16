import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projek_pab_duit/themes/colors.dart';

class MonthCarouselWidget extends StatefulWidget {
  final List<DateTime> availableMonths;
  final DateTime? selectedMonth;
  final ScrollController scrollController;
  final Function(DateTime) onMonthChanged;

  const MonthCarouselWidget({
    super.key,
    required this.availableMonths,
    required this.selectedMonth,
    required this.scrollController,
    required this.onMonthChanged,
  });

  @override
  State<MonthCarouselWidget> createState() => _MonthCarouselWidgetState();
}

class _MonthCarouselWidgetState extends State<MonthCarouselWidget> {
  late PageController _pageController;
  int _currentIndex = 12; //Ini masih statis Han tolong diubah logicnya hehe

  @override
  void initState() {
    super.initState();
    _initializePosition();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 1.0 / 3.0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Menginisialisasi posisi awal carousel berdasarkan bulan yang dipilih
  void _initializePosition() {
    if (widget.selectedMonth != null && widget.availableMonths.isNotEmpty) {
      final index = widget.availableMonths.indexWhere(
        (month) =>
            month.year == widget.selectedMonth!.year &&
            month.month == widget.selectedMonth!.month,
      );
      if (index != -1) {
        _currentIndex = index; //nyambung kesini
      }
    }
  }

  // Dipanggil saat halaman/bulan digeser (swipe)
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onMonthChanged(widget.availableMonths[index]);
  }

  // Dipanggil saat salah satu bulan di-tap
  void _onMonthTap(int index) {
    // Animasikan ke halaman yang di-tap jika bukan halaman saat ini
    if (index != _currentIndex) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Fungsi untuk format bulan dengan fallback
  String _formatMonth(DateTime month) {
    try {
      return DateFormat('MMM yyyy', 'id_ID').format(month);
    } catch (e) {
      const monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${monthNames[month.month - 1]} ${month.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.availableMonths.isEmpty) {
      return const SizedBox(height: 50);
    }

    // Menghitung lebar area untuk satu item bulan
    // Lebar layar dikurangi margin horizontal (24 * 2), lalu dibagi 3
    final double itemWidth = (MediaQuery.of(context).size.width - 48) / 3;

    // Container utama yang berfungsi sebagai card latar belakang
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 34, 34, 77),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: itemWidth,
            height: 40,
            decoration: BoxDecoration(
              color: DarkColors.bg1.withAlpha(100),
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // PageView untuk bulan (di lapisan depan)
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.availableMonths.length,
            itemBuilder: (context, index) {
              final month = widget.availableMonths[index];
              final monthString = _formatMonth(month);

              // Menentukan apakah item ini adalah item yang sedang di tengah
              final isSelected = index == _currentIndex;

              return GestureDetector(
                onTap: () => _onMonthTap(index),
                // Container transparan untuk memastikan area tap berfungsi
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        // Bulan yang di tengah berwarna putih dan tebal
                        color:
                            isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                      child: Text(monthString),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
