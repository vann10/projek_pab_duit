import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projek_pab_duit/db/database_helper.dart';
import 'package:projek_pab_duit/screens/home_page.dart';

// START: MODIFICATION
class CreditCardModel {
  final int id;
  final String cardName;
  final String cardNumber;
  final String expiryDate;
  final String logoAsset;
  final Gradient gradient;
  final int saldo;

  CreditCardModel({
    required this.id,
    required this.cardName,
    required this.cardNumber,
    required this.expiryDate,
    required this.logoAsset,
    required this.gradient,
    required this.saldo,
  });

  factory CreditCardModel.fromMap(Map<String, dynamic> map, int index) {
    String cardNumber =
        "1234 5678 9012 ${(3456 + index).toString().padLeft(4, '0')}";

    DateTime now = DateTime.now();
    DateTime expiry = DateTime(now.year + 2 + (index % 3), now.month);
    String expiryDate =
        "${expiry.month.toString().padLeft(2, '0')}/${expiry.year.toString().substring(2)}";

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
      id: map['id'], // Pass the wallet ID
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
  final VoidCallback onDelete;
  const CreditCardWidget({
    super.key,
    required this.card,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedSaldo = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(card.saldo);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: card.gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 35,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              if (card.id != 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF2E2D4A),
                          title: const Text(
                            'Konfirmasi Hapus',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            'Apakah Anda yakin ingin menghapus dompet "${card.cardName}"? Semua transaksi yang terhubung juga akan terhapus.',
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'Batal',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              onPressed: () async {
                                final success = await DatabaseHelper.instance
                                    .deleteDompet(card.id);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Dompet berhasil dihapus'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const HomePage()),
                                  );
                                  onDelete();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Gagal menghapus Dompet Utama',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              else
                const Icon(Icons.wifi, color: Colors.white, size: 20),
            ],
          ),

          const Spacer(),

          Text(
            card.cardNumber,
            style: GoogleFonts.sourceCodePro(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            formattedSaldo,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Name',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 8,
                      ),
                    ),
                    Text(
                      card.cardName,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expires',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 8,
                    ),
                  ),
                  Text(
                    card.expiryDate,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardCarouselWidget extends StatefulWidget {
  final VoidCallback? onDataChanged;
  const CardCarouselWidget({super.key, this.onDataChanged});

  @override
  State<CardCarouselWidget> createState() => _CardCarouselWidgetState();
}

class _CardCarouselWidgetState extends State<CardCarouselWidget> {
  int _currentCard = 0;
  Future<List<Map<String, dynamic>>>? _dompetFuture;

  @override
  void initState() {
    super.initState();
    _dompetFuture = DatabaseHelper.instance.getAllDompet();
  }

  void _refreshData() {
    setState(() {
      _dompetFuture = DatabaseHelper.instance.getAllDompet();
    });

    if (widget.onDataChanged != null) {
      widget.onDataChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _dompetFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 240,
            child: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 240,
            child: Center(
              child: Text(
                'Tidak ada dompet tersedia',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
          );
        } else {
          final dompetList = snapshot.data!;
          final cards =
              dompetList.asMap().entries.map((entry) {
                return CreditCardModel.fromMap(entry.value, entry.key);
              }).toList();

          if (_currentCard >= cards.length && cards.isNotEmpty) {
            _currentCard = cards.length - 1;
          }

          return SizedBox(
            height: 240,
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index, realIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CreditCardWidget(
                        card: cards[index],
                        onDelete: _refreshData,
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 0.85,
                    initialPage: _currentCard,
                    enableInfiniteScroll: cards.length > 1,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentCard = index;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      cards.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(
                              _currentCard == entry.key ? 0.9 : 0.4,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}