import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projek_pab_duit/db/database_helper.dart';

class CreditCardModel {
  final String cardHolderName;
  final String cardNumber;
  final String expiryDate;
  final String logoAsset;
  final Gradient gradient;

  CreditCardModel({
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.logoAsset,
    required this.gradient,
  });
}

final List<CreditCardModel> cardData = [
  CreditCardModel(
    cardHolderName: "Jokowi Pekok",
    cardNumber: "1234 5678 9012 3456",
    expiryDate: "09/24",
    logoAsset: "assets/images/mastercard.png",
    gradient: const LinearGradient(
      colors: [Color(0xFFFFD700), Color(0xFFE48F23), Color(0xFFC0392B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  CreditCardModel(
    cardHolderName: "Prabowo Pekok",
    cardNumber: "9876 5432 1098 7654",
    expiryDate: "11/25",
    logoAsset: "assets/images/mastercard.png",
    gradient: const LinearGradient(
      colors: [Color(0xFF4e54c8), Color(0xFF8f94fb)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  CreditCardModel(
    cardHolderName: "Gibran Pekok",
    cardNumber: "5555 6666 7777 8888",
    expiryDate: "01/26",
    logoAsset: "assets/images/mastercard.png",
    gradient: const LinearGradient(
      colors: [Color(0xFF00c6ff), Color(0xFF0072ff)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
];

class CreditCardWidget extends StatelessWidget {
  final CreditCardModel card;
  const CreditCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: card.gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/chip.png', width: 45),
              const Icon(Icons.wifi, color: Colors.white, size: 28),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.cardNumber,
                style: GoogleFonts.sourceCodePro(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card Holder',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        card.cardHolderName,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expires',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        card.expiryDate,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(card.logoAsset, width: 50),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<int>(
        future: DatabaseHelper.instance.getTotalSaldo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.poppins(color: Colors.red),
            );
          } else {
            final total = snapshot.data ?? 0;

            final formattedSaldo = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(total);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedSaldo,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Available Balance',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
