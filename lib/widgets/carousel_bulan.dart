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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializePosition();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 1.0 / 3.0, // Menampilkan 3 item sekaligus
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _initializePosition() {
    if (widget.selectedMonth != null && widget.availableMonths.isNotEmpty) {
      final index = widget.availableMonths.indexWhere(
        (month) =>
            month.year == widget.selectedMonth!.year &&
            month.month == widget.selectedMonth!.month,
      );
      if (index != -1) {
        _currentIndex = index;
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onMonthChanged(widget.availableMonths[index]);
  }

  void _onMonthTap(int index) {
    if (index != _currentIndex) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Fungsi untuk format bulan dengan fallback jika locale belum diinisialisasi
  String _formatMonth(DateTime month) {
    try {
      return DateFormat('MMM yyyy', 'id_ID').format(month);
    } catch (e) {
      // Fallback ke format manual jika locale belum diinisialisasi
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

    return SizedBox(
      height: 50,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: widget.availableMonths.length,
        itemBuilder: (context, index) {
          final month = widget.availableMonths[index];
          final monthString = _formatMonth(month);

          // Menentukan status berdasarkan posisi relatif terhadap index saat ini
          final isSelected = index == _currentIndex;
          final isAdjacent =
              (index == _currentIndex - 1) || (index == _currentIndex + 1);

          return GestureDetector(
            onTap: () => _onMonthTap(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? const Color(0xFF4A90E2) // Biru untuk yang dipilih
                          : Colors
                              .transparent, // Transparan untuk yang tidak dipilih
                  borderRadius: BorderRadius.circular(25),
                  border:
                      !isSelected
                          ? Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          )
                          : null,
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: const Color(0xFF4A90E2).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                          : [],
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color:
                          isSelected
                              ? Colors
                                  .white // Putih untuk yang dipilih
                              : Colors.white.withOpacity(
                                0.5,
                              ), // Abu-abu untuk yang tidak dipilih
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                    child: Text(monthString),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
