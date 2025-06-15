import 'package:flutter/material.dart';

Widget buildIcon({
  required IconData icon,
  required int index,
  required int currentIndex,
  required Function(int) onTap,
}) {
  final isSelected = currentIndex == index;

  return GestureDetector(
    onTap: () => onTap(index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Transform.translate(
        offset: const Offset(0, -10),
        child: Transform.scale(
          scale: isSelected ? 1.5 : 1.3,
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
