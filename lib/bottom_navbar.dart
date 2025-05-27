import 'dart:ui';

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
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: BottomAppBar(
          color: Color(0xFF141326).withOpacity(0.9),
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIcon(Icons.home, 0),
                _buildIcon(Icons.account_balance_wallet, 1),
                _buildIcon(Icons.bar_chart, 2),
                _buildIcon(Icons.person, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Transform.translate(
          offset: const Offset(0, -10), // geser 6 piksel ke atas
          child: Transform.scale(
            scale: isSelected ? 1.3 : 1,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}
