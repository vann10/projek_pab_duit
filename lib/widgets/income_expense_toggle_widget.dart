import 'package:flutter/material.dart';
import 'package:projek_pab_duit/screens/statistic_page.dart';

class IncomeExpenseToggleWidget extends StatelessWidget {
  final StatType selectedType;
  final Function(StatType) onTypeChanged;

  const IncomeExpenseToggleWidget({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
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
      onTap: () => onTypeChanged(type),
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
