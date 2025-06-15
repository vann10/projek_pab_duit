
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:projek_pab_duit/widgets/build_icon.dart';

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
        child: Container(
          // Solusi 2: Container dengan behavior opaque
          color: Colors.transparent,
          child: BottomAppBar(
            color: const Color(0xFF141326).withOpacity(0.9),
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildIcon(
                    icon: Icons.home,
                    index: 0,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                  buildIcon(
                    icon: Icons.account_balance_wallet,
                    index: 1,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                  buildIcon(
                    icon: Icons.bar_chart,
                    index: 2,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                  buildIcon(
                    icon: Icons.person,
                    index: 3,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
