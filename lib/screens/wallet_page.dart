import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_pab_duit/widgets/add_credit_card.dart';
import 'package:projek_pab_duit/widgets/carousel_card.dart';
import 'package:projek_pab_duit/widgets/credit_card.dart';


class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const CardCarouselWidget(),
              const SizedBox(height: 20),
              const BalanceWidget(),
              const SizedBox(height: 20),
              const AddCardFormWidget(),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}
