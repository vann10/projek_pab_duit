import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projek_pab_duit/themes/colors.dart';

class MonthCarouselWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Jika tidak ada bulan yang tersedia, tampilkan container kosong.
    if (availableMonths.isEmpty) {
      return const SizedBox(height: 50);
    }

    return SizedBox(
      height: 50, // Beri tinggi tetap untuk area scroll
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children:
              availableMonths.map((month) {
                final isSelected =
                    selectedMonth != null &&
                    month.year == selectedMonth!.year &&
                    month.month == selectedMonth!.month;
                // Format tanggal menjadi "Juni 2025"
                final monthString = DateFormat(
                  'MMMM yyyy',
                  'id_ID',
                ).format(month);

                return GestureDetector(
                  onTap: () => onMonthChanged(month),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? DarkColors.oren : DarkColors.monthly,
                      borderRadius: BorderRadius.circular(25),
                      border:
                          isSelected
                              ? null
                              : Border.all(
                                color: DarkColors.oren.withOpacity(0.5),
                              ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: DarkColors.oren.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                              : [],
                    ),
                    child: Center(
                      child: Text(
                        monthString,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.8),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
