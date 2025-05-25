import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomAppBar(
        color: Colors.black.withValues(alpha: 0.5), // semi-transparan
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIcon(Icons.home, 0),
              _buildIcon(Icons.account_balance_wallet, 1),
              _buildIcon(Icons.bar_chart, 2, isCenter: true),
              _buildIcon(Icons.person, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index, {bool isCenter = false}) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          size: currentIndex == index ? 27 : 24,
          color: currentIndex == index ? Colors.white : Colors.white54,
        ),
      ),
    );
  }
}
