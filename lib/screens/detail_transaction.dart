import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:intl/intl.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({required this.name, required this.icon, required this.color});
}

class DetailTransactionPage extends StatefulWidget {
  const DetailTransactionPage({super.key});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  late DateTime _selectedDateTime;

  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  bool _isCategoryOverlayVisible = false;
  OverlayEntry? _categoryOverlayEntry;
  final LayerLink _categoryLayerLink = LayerLink();

  bool _isPaymentOverlayVisible = false;
  OverlayEntry? _paymentOverlayEntry;
  final LayerLink _paymentLayerLink = LayerLink();

  final List<CategoryItem> _categories = [
    CategoryItem(
      name: 'Kebutuhan',
      icon: Icons.shopping_cart,
      color: Colors.cyan,
    ),
    CategoryItem(name: 'Pakaian', icon: Icons.checkroom, color: Colors.purple),
    CategoryItem(
      name: 'Elektronik',
      icon: Icons.desktop_windows,
      color: Colors.orange,
    ),
    CategoryItem(name: 'Investasi', icon: Icons.bar_chart, color: Colors.amber),
    CategoryItem(name: 'Kehidupunk', icon: Icons.people, color: Colors.green),
    CategoryItem(
      name: 'Transportasi',
      icon: Icons.directions_bus,
      color: Colors.red,
    ),
  ];
  late CategoryItem _selectedCategory;

  // Payment Methods
  String _selectedPaymentMethod = 'Uang Tunai';
  final List<String> _paymentMethods = [
    'Uang Tunai',
    'Kartu Kredit',
    'Transfer Bank',
    'E-Wallet',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
    _selectedCategory = _categories.firstWhere(
      (item) => item.name == 'Kebutuhan',
    );

    _amountController = TextEditingController(text: 'Rp500');
    _descriptionController = TextEditingController(text: 'Judol');
  }

  // Category Overlay Methods
  void _removeCategoryOverlay() {
    _categoryOverlayEntry?.remove();
    _categoryOverlayEntry = null;
    setState(() {
      _isCategoryOverlayVisible = false;
    });
  }

  void _showCategoryOverlay() {
    _removeCategoryOverlay();

    _categoryOverlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeCategoryOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _categoryLayerLink,
              showWhenUnlinked: false,
              offset: const Offset(
                0.0,
                60.0,
              ), // Adjust based on your card height
              child: Material(
                color: Colors.transparent,
                child: _buildCategoryOverlayPanel(),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_categoryOverlayEntry!);
    setState(() {
      _isCategoryOverlayVisible = true;
    });
  }

  Widget _buildCategoryOverlayPanel() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth - 32,
      margin: EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2D4A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'ALL CATEGORIES',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ..._categories
              .map((category) => _buildCategoryRow(category))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(CategoryItem category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
        _removeCategoryOverlay();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
              ),
              child: Icon(category.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              category.name,
              style: TextStyle(
                color:
                    _selectedCategory == category
                        ? DarkColors.oren
                        : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removePaymentOverlay() {
    _paymentOverlayEntry?.remove();
    _paymentOverlayEntry = null;
    setState(() {
      _isPaymentOverlayVisible = false;
    });
  }

  void _showPaymentOverlay() {
    _removePaymentOverlay();

    _paymentOverlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _removePaymentOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _paymentLayerLink,
              showWhenUnlinked: false,
              offset: const Offset(0.0, 60.0),
              child: Material(
                color: Colors.transparent,
                child: _buildPaymentOverlayPanel(),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_paymentOverlayEntry!);
    setState(() {
      _isPaymentOverlayVisible = true;
    });
  }

  Widget _buildPaymentOverlayPanel() {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2D4A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'PAYMENT METHODS',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ..._paymentMethods
              .map((method) => _buildPaymentMethodRow(method))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodRow(String method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
        _removePaymentOverlay();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          method,
          style: TextStyle(
            color:
                _selectedPaymentMethod == method
                    ? DarkColors.oren
                    : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _removeCategoryOverlay();
    _removePaymentOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-1.0, -1.5),
            radius: 2,
            colors: [
              Color.fromARGB(133, 20, 19, 38),
              Color.fromARGB(132, 64, 204, 232),
              Color.fromARGB(132, 20, 19, 38),
            ],
            stops: [0.0, 0.5, 1],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Detail Transaksi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: () {
                        developer.log('$_amountController.text');
                        developer.log('$_descriptionController.text');
                        developer.log('$_selectedCategory.text');
                        developer.log('$_selectedPaymentMethod');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Transaction Time
                _buildDetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TRANSAKSI',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickDateTime,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Row(
                            children: [
                              Text(
                                DateFormat('h:mm a').format(_selectedDateTime),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '|',
                                style: TextStyle(color: DarkColors.oren),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat(
                                  'MMM dd, yyyy',
                                ).format(_selectedDateTime),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: DarkColors.oren,
                        thickness: 1,
                        height: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Category Custom Dropdown
                CompositedTransformTarget(
                  link: _categoryLayerLink,
                  child: _buildDetailCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'KATEGORI',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _showCategoryOverlay,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _selectedCategory.color,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _selectedCategory.icon,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  _selectedCategory.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Icon(
                                _isCategoryOverlayVisible
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: DarkColors.oren,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: DarkColors.oren,
                          thickness: 1,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Amount
                _buildDetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'JUMLAH',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const Divider(
                        color: DarkColors.oren,
                        thickness: 1,
                        height: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Method Custom Dropdown
                CompositedTransformTarget(
                  link: _paymentLayerLink,
                  child: _buildDetailCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'METODE PEMBAYARAN',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _showPaymentOverlay,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedPaymentMethod,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Icon(
                                _isPaymentOverlayVisible
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: DarkColors.oren,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: DarkColors.oren,
                          thickness: 1,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                _buildDetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DESKRIPSI',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const Divider(
                        color: DarkColors.oren,
                        thickness: 1,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(92, 50, 75, 106),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(132, 64, 204, 232)),
      ),
      child: child,
    );
  }
}
