import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// CategoryItem class definition
class CategoryItem {
  final int id;
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class TransactionCard extends StatelessWidget {
  final String merchantName;
  final String date;
  final String deskripsi;
  final int amount;
  final String logoAsset;
  final String tipe;
  final Color backgroundColor;
  final VoidCallback onTap;

  // Static category lists
  static final List<CategoryItem> _categoriesExpense = [
    CategoryItem(id: 1, name: 'Makanan', icon: Icons.fastfood, color: Colors.orange),
    CategoryItem(id: 2, name: 'Kebutuhan', icon: Icons.shopping_cart, color: Colors.cyan),
    CategoryItem(id: 3, name: 'Pakaian', icon: Icons.checkroom, color: Colors.purple),
    CategoryItem(id: 4, name: 'Tabungan', icon: Icons.bar_chart, color: Colors.amber),
    CategoryItem(id: 5, name: 'Sosial', icon: Icons.people, color: Colors.green),
    CategoryItem(id: 6, name: 'Transportasi', icon: Icons.directions_bus, color: Colors.red),
    CategoryItem(id: 7, name: 'Lainnya', icon: Icons.more_horiz, color: Colors.grey),
  ];

  static final List<CategoryItem> _categoriesIncome = [
    CategoryItem(id: 8, name: 'Gaji', icon: Icons.paid, color: Colors.green),
    CategoryItem(id: 9, name: 'Bonus', icon: Icons.redeem, color: Colors.cyan),
    CategoryItem(id: 10, name: 'Uang Saku', icon: Icons.payment, color: Colors.orange),
    CategoryItem(id: 11, name: 'Lainnya', icon: Icons.more_horiz, color: Colors.grey),
  ];

  const TransactionCard({
    super.key,
    required this.merchantName,
    required this.date,
    required this.deskripsi,
    required this.amount,
    required this.logoAsset,
    required this.tipe,
    required this.onTap,
    this.backgroundColor = const Color(0xFF141326),
  });

  String formatRupiah(int amount, {String prefix = 'Rp'}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: prefix,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Method to get accent color based on merchantName and transaction type
  Color getAccentColor() {
    List<CategoryItem> categories;
    
    // Choose category list based on transaction type
    if (tipe == 'INCOME') {
      categories = _categoriesIncome;
    } else {
      categories = _categoriesExpense;
    }

    // Find matching category by name
    try {
      final category = categories.firstWhere(
        (cat) => cat.name.toLowerCase() == merchantName.toLowerCase(),
      );
      return category.color;
    } catch (e) {
      // Return default color if no match found
      return const Color(0xFFFF6B35);
    }
  }

  @override
  Widget build(BuildContext context) {
    final amountColor = tipe == 'INCOME' ? Colors.greenAccent : Colors.red;
    final accentColor = getAccentColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(logoAsset, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            merchantName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            deskripsi,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        formatRupiah(amount),
                        style: TextStyle(
                          color: amountColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}