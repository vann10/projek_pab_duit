import 'package:flutter/material.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:projek_pab_duit/screens/statistic_page.dart';

class PeriodFilterWidget extends StatelessWidget {
  final StatPeriod selectedPeriod;
  final Function(StatPeriod) onPeriodChanged;

  const PeriodFilterWidget({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  static final Map<StatPeriod, BoxDecoration> _selectedFilterDecoration = {
    StatPeriod.Daily: BoxDecoration(
      color: DarkColors.daily.withOpacity(0.35),
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
        onTap: () => onPeriodChanged(period),
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
}
