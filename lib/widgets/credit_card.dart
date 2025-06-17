import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projek_pab_duit/db/database_helper.dart';

class CreditCardModel {
  final String cardName;
  final String cardNumber;
  final String expiryDate;
  final String logoAsset;
  final Gradient gradient;
  final int saldo;

  CreditCardModel({
    required this.cardName,
    required this.cardNumber,
    required this.expiryDate,
    required this.logoAsset,
    required this.gradient,
    required this.saldo,
  });

  factory CreditCardModel.fromMap(Map<String, dynamic> map, int index) {
    // Generate card number based on index or id
    String cardNumber =
        "1234 5678 9012 ${(3456 + index).toString().padLeft(4, '0')}";

    // Generate expiry date (current year + 2-4 years)
    DateTime now = DateTime.now();
    DateTime expiry = DateTime(now.year + 2 + (index % 3), now.month);
    String expiryDate =
        "${expiry.month.toString().padLeft(2, '0')}/${expiry.year.toString().substring(2)}";

    // Gradient colors array
    List<List<Color>> gradients = [
      [
        const Color(0xFFFFD700),
        const Color(0xFFE48F23),
        const Color(0xFFC0392B),
      ],
      [const Color(0xFF4e54c8), const Color(0xFF8f94fb)],
      [const Color(0xFF00c6ff), const Color(0xFF0072ff)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      [const Color(0xFFfa709a), const Color(0xFFfee140)],
      [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
    ];

    return CreditCardModel(
      cardName: map['nama'] ?? 'Card ${index + 1}',
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      logoAsset: "assets/images/mastercard.png",
      gradient: LinearGradient(
        colors: gradients[index % gradients.length],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      saldo: map['saldo'] ?? 0,
    );
  }
}

class CreditCardWidget extends StatelessWidget {
  final CreditCardModel card;
  const CreditCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final formattedSaldo = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(card.saldo);

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
              const SizedBox(height: 10),
              // Balance display
              Text(
                formattedSaldo,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
                        'Card Name',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        card.cardName,
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

class DynamicCreditCardList extends StatelessWidget {
  const DynamicCreditCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getAllDompet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No cards available',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          );
        } else {
          final dompetList = snapshot.data!;
          return SizedBox(
            height: 220,
            child: PageView.builder(
              itemCount: dompetList.length,
              controller: PageController(viewportFraction: 0.85),
              itemBuilder: (context, index) {
                final card = CreditCardModel.fromMap(dompetList[index], index);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CreditCardWidget(card: card),
                );
              },
            ),
          );
        }
      },
    );
  }
}

// Updated BalanceWidget to show total from all cards
class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getAllDompet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.poppins(color: Colors.red),
            );
          } else {
            final dompetList = snapshot.data ?? [];
            final totalSaldo = dompetList.fold<int>(
              0,
              (sum, dompet) => sum + (dompet['saldo'] as int? ?? 0),
            );

            final formattedSaldo = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(totalSaldo);

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
                  'Total Available Balance',
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
