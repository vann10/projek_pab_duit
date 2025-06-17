import 'package:flutter/material.dart';
import 'package:projek_pab_duit/widgets/saving_plan_card.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Coming Soon',
        style: TextStyle(color: Colors.white54, fontSize: 24),
        textAlign: TextAlign.start,
      ),
    );
  }
}
