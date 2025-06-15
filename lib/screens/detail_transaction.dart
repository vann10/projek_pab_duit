import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:projek_pab_duit/db/database_helper.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:intl/intl.dart';

class CategoryItem {
  final int id;
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({required this.id, required this.name, required this.icon, required this.color});
}

class DetailTransactionPage extends StatefulWidget {
  final Map<String, dynamic>? transactionData;
  
  const DetailTransactionPage({super.key, this.transactionData});

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

  final List<CategoryItem> _categoriesExpense = [
    CategoryItem(id: 1, name: 'Makanan', icon: Icons.fastfood, color: Colors.orange),
    CategoryItem(id: 2, name: 'Kebutuhan', icon: Icons.shopping_cart, color: Colors.cyan),
    CategoryItem(id: 3, name: 'Pakaian', icon: Icons.checkroom, color: Colors.purple),
    CategoryItem(id: 4, name: 'Tabungan', icon: Icons.bar_chart, color: Colors.amber),
    CategoryItem(id: 5, name: 'Sosial', icon: Icons.people, color: Colors.green),
    CategoryItem(id: 6, name: 'Transportasi', icon: Icons.directions_bus, color: Colors.red),
    CategoryItem(id: 7, name: 'Lainnya', icon: Icons.more_horiz, color: Colors.grey),
  ];
  final List<CategoryItem> _categoriesIncome = [
    CategoryItem(id: 8, name: 'Gaji', icon: Icons.paid, color: Colors.green),
    CategoryItem(id: 9, name: 'Bonus', icon: Icons.redeem, color: Colors.cyan),
    CategoryItem(id: 10, name: 'Uang Saku', icon: Icons.payment, color: Colors.orange),
    CategoryItem(id: 11, name: 'Lainnya', icon: Icons.more_horiz, color: Colors.grey),
  ];
  late CategoryItem _selectedCategory;
  late List<CategoryItem> _categories;

  // Payment Methods
  String? _selectedPaymentMethod;
  int? _selectedPaymentMethodId;
  List<Map<String, dynamic>> _paymentMethods = [];
  bool _isLoadingPaymentMethods = true;

  Future<void> _loadPaymentMethods() async {
    try {
      // Ganti dengan service database Anda untuk query: SELECT id, nama, saldo FROM dompet
      final response = await DatabaseHelper.instance.getAllDompet(); 
      
      if (response != null && response.isNotEmpty) {
        setState(() {
          _paymentMethods = response;
          _isLoadingPaymentMethods = false;
          
          // Set default payment method
          if (widget.transactionData != null) {
            final dompetNama = widget.transactionData!['dompet_nama'];
            final selectedDompet = _paymentMethods.firstWhere(
              (dompet) => dompet['nama'] == dompetNama,
              orElse: () => _paymentMethods.first,
            );
            _selectedPaymentMethod = selectedDompet['nama'];
            _selectedPaymentMethodId = selectedDompet['id'];
          } else {
            _selectedPaymentMethod = _paymentMethods.first['nama'];
            _selectedPaymentMethodId = _paymentMethods.first['id'];
          }
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingPaymentMethods = false;
      });
      print('Error loading payment methods: $e');
    }
  }
  String formatRupiah(double amount, {String prefix = 'Rp'}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: prefix,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
    
    // Initialize with transaction data if available
    if (widget.transactionData != null) {
      final data = widget.transactionData!;

      if(data['tipe'] == 'EXPENSE'){
        _categories = _categoriesExpense;
      } else _categories = _categoriesIncome;
      
      // Parse date
      if (data['tanggal'] != null) {
        try {
          _selectedDateTime = DateTime.parse(data['tanggal']);
        } catch (e) {
          _selectedDateTime = DateTime.now();
        }
      } else {
        _selectedDateTime = DateTime.now();
      }
      
      // Set amount
      final amount = data['jumlah'] ?? 0.0;
      _amountController = TextEditingController(
        text: formatRupiah(amount.toDouble())
      );
      
      // Set description
      _descriptionController = TextEditingController(
        text: data['deskripsi'] ?? ''
      );
      
      // Set category based on kategori_nama or default to first category
      final kategoriNama = data['kategori_nama'];
      _selectedCategory = _categories.firstWhere(
        (item) => item.name.toLowerCase() == kategoriNama?.toLowerCase(),
        orElse: () => _categories.first,
      );
      
      // Set payment method based on dompet_nama or default
      final dompetNama = data['dompet_nama'];
      if (dompetNama != null && _paymentMethods.contains(dompetNama)) {
        _selectedPaymentMethod = dompetNama;
      }
      
    } else {
      // Default values for new transaction
      _selectedDateTime = DateTime.now();
      _selectedCategory = _categories.firstWhere(
        (item) => item.name == 'Makanan',
      );
      _amountController = TextEditingController(text: 'Rp0');
      _descriptionController = TextEditingController(text: '-');
    }
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

  Widget _buildPaymentMethodRow(Map<String, dynamic> method) {
    final methodName = method['nama'];
    final methodId = method['id'];
    final saldo = method['saldo'];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = methodName;
          _selectedPaymentMethodId = methodId;
        });
        _removePaymentOverlay();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              methodName,
              style: TextStyle(
                color: _selectedPaymentMethod == methodName
                    ? DarkColors.oren
                    : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              formatRupiah(saldo.toDouble()),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
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
    _amountController.dispose();
    _descriptionController.dispose();
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
                    Text(
                      widget.transactionData != null ? 'Detail Transaksi' : 'Tambah Transaksi',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: () {
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
                if (widget.transactionData == null || widget.transactionData!['tipe'] == 'EXPENSE')
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
                                    _selectedPaymentMethod ?? 'Loading...',
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
                if (widget.transactionData == null || widget.transactionData!['tipe'] == 'EXPENSE')
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