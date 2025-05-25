import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

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
    final theme = Theme.of(context);

    return Positioned(
      bottom: 18,
      left: 18,
      right: 18,
      height: 86,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: theme.scaffoldBackgroundColor),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(52),
            bottomRight: Radius.circular(52),
          ),
          color: theme.scaffoldBackgroundColor.withOpacity(0.1),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(52),
            bottomRight: Radius.circular(52),
          ),
          child: ClipPath(
            clipper: MyCustomClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return ZoomTapAnimation(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          size: isSelected ? 27 : 24,
          color: isSelected ? Colors.white : Colors.white38,
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 64, size.height);
    path.lineTo(64, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
