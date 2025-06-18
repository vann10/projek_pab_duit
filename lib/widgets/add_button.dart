// lib/widgets/add_button.dart
import 'package:flutter/material.dart';
import 'package:projek_pab_duit/themes/colors.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 145,
      right: 30,
      child: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: onPressed ,
        backgroundColor: DarkColors.oren,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }
}
