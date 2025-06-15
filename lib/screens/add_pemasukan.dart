import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projek_pab_duit/db/database_helper.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:intl/intl.dart';
import 'package:another_flushbar/flushbar.dart';

class AddPemasukanPage extends StatefulWidget {
  const AddPemasukanPage({super.key});

  @override
  State<AddPemasukanPage> createState() => _AddPemasukanPageState();
}

class _AddPemasukanPageState extends State<AddPemasukanPage> {
  String _amount = '';
  bool _isExpense = true;
  bool _showDropdown = false;
  String _description = '-';
  String _category = 'Makanan';
  bool _isFlushbarShowing = false;
  bool _isSubmitting = false;

  // Add TextEditingController for description
  late TextEditingController _descriptionController;

  List<String> _dropdownItems = [];
  String? _selectedItem;

  Future<void> _loadDropdownItems() async {
    List<String> items = [];

    if (_isExpense) {
      // Ambil kategori bertipe EXPENSE atau BOTH
      final kategoriList = await DatabaseHelper.instance.getKategoriByTipe("EXPENSE");
      items = kategoriList.map((row) => row['nama'] as String).toList();
    } else {
      // Ambil semua dompet
      final dompetList = await DatabaseHelper.instance.getKategoriByTipe("INCOME");
      items = dompetList.map((row) => row['nama'] as String).toList();
    }

    setState(() {
      _dropdownItems = items;
      // Set item pertama sebagai selected item dan update category
      if (items.isNotEmpty) {
        _selectedItem = items.first;
        _category = items.first;
      } else {
        _selectedItem = null;
        _category = _isExpense ? 'Makanan' : 'Dompet Utama';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _loadDropdownItems();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onNumberPress(String value) {
    final raw = _amount.replaceAll(',', '');

    // Validasi maksimal 13 digit
    if (raw.length >= 13) {
      _showMessage("Maksimal input adalah 13 digit", isError: true);
      return;
    }

    final newRaw = raw + value;
    final number = int.tryParse(newRaw) ?? 0;

    setState(() {
      _amount = _formatCurrency(number);
    });
  }

  void _onBackspace() {
    setState(() {
      final raw = _amount.replaceAll(',', '');
      if (raw.isNotEmpty) {
        final newRaw = raw.substring(0, raw.length - 1);
        final number = int.tryParse(newRaw) ?? 0;
        _amount = newRaw.isEmpty ? '' : _formatCurrency(number);
      }
    });
  }

  // Perbaiki fungsi format currency
  String _formatCurrency(int value) {
    if (value == 0) return '';
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }

  // Helper untuk mendapatkan raw value
  int _getRawAmount() {
    final raw = _amount.replaceAll(',', '');
    return int.tryParse(raw) ?? 0;
  }

  Widget numButton(String value, {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(16),
        minimumSize: const Size(60, 60),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 28, color: Colors.white),
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    if (_isFlushbarShowing) return;

    _isFlushbarShowing = true;

    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 600),
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(
        isError ? Icons.error : Icons.check_circle,
        color: Colors.white,
      ),
    ).show(context).then((_) {
      if (mounted) {
        _isFlushbarShowing = false;
      }
    });
  }

  Future<void> _submitForm() async {
    // Mencegah double submit
    if (_isSubmitting) return;

    final jumlah = _getRawAmount();
    final description = _descriptionController.text.trim();

    // Validasi input
    if (jumlah <= 0) {
      _showMessage("Masukkan jumlah yang valid", isError: true);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simpan ke database
      final success = await DatabaseHelper.instance.insertTransaksiWithUpdateSaldo(
        jumlah: jumlah,
        kategori: _category,
        deskripsi: _description,
        tipe: _isExpense ? 'EXPENSE' : 'INCOME',
        dompetId: 1,
      );

      if (success) {
        _showMessage(
          "${_isExpense ? 'Pengeluaran' : 'Pemasukan'} berhasil disimpan!",
        );

        // Tunggu sebentar agar user bisa melihat pesan sukses
        await Future.delayed(const Duration(milliseconds: 1000));

        // Kembali ke halaman sebelumnya dengan result
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (Route<dynamic> route) => false, // Hapus semua route sebelumnya
          );
        }
      } else {
        _showMessage("Gagal menyimpan data", isError: true);
      }
    } catch (e) {
      _showMessage("Terjadi kesalahan: ${e.toString()}", isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // Fungsi untuk validasi input keyboard
  void _onDescriptionChanged(String value) {
    setState(() {
      _description = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: DarkColors.bg,
      resizeToAvoidBottomInset: false,
      // Add floating action button that's always visible
      floatingActionButton: isKeyboardVisible
          ? FloatingActionButton(
              onPressed: _isSubmitting ? null : _submitForm,
              backgroundColor: _isSubmitting ? Colors.grey : DarkColors.oren,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.check, color: Colors.white),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),

                      // Income / Expense toggle
                      Container(
                        margin: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                        ),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade700,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() => _isExpense = false);
                                  // Muat ulang dropdown ketika toggle berubah
                                  await _loadDropdownItems();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !_isExpense ? Colors.green : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "INCOME",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() => _isExpense = true);
                                  // Muat ulang dropdown ketika toggle berubah
                                  await _loadDropdownItems();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isExpense ? Colors.red : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "EXPENSE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Category Dropdown Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showDropdown = !_showDropdown;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 120),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 58, 32, 119),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2),
                              bottomLeft: Radius.elliptical(80, 160),
                              bottomRight: Radius.elliptical(80, 160),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Text(
                                    _category,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  _showDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          "${_isExpense ? '-' : '+'} Rp${_amount.isEmpty ? '0' : _amount}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description Input
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _descriptionController,
                          style: const TextStyle(color: Colors.white),
                          maxLength: 100, // Batasi panjang deskripsi
                          decoration: const InputDecoration(
                            hintText: "Add Description",
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: DarkColors.oren),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: DarkColors.oren),
                            ),
                            counterStyle: TextStyle(color: Colors.white70),
                          ),
                          onChanged: _onDescriptionChanged,
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),

                  // Dropdown overlay
                  if (_showDropdown)
                    Positioned(
                      top: 140,
                      left: 120,
                      right: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 58, 32, 119),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: _dropdownItems
                                  .map(
                                    (item) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedItem = item;
                                          _category = item;
                                          _showDropdown = false;
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          vertical: _dropdownItems.length > 5 ? 10 : 12, 
                                          horizontal: 16,
                                        ),
                                        constraints: const BoxConstraints(
                                          minHeight: 40,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _selectedItem == item
                                              ? Colors.white.withOpacity(0.2)
                                              : Colors.transparent,
                                        ),
                                        child: Center(
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              color: _selectedItem == item ? Colors.white : Colors.white70,
                                              fontWeight: _selectedItem == item
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              fontSize: _dropdownItems.length > 7 ? 14 : 16,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Numpad (only show when keyboard is not visible)
            if (!isKeyboardVisible)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    for (var i = 0; i < 3; i++)
                      SizedBox(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(3, (index) {
                              final num = (1 + 3 * i + index).toString();
                              return numButton(
                                num,
                                onPressed: () => _onNumberPress(num),
                              );
                            }),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Backspace
                          TextButton(
                            onPressed: _onBackspace,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              minimumSize: const Size(60, 60),
                            ),
                            child: const Icon(
                              Icons.backspace,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),

                          // 0
                          numButton('0', onPressed: () => _onNumberPress('0')),

                          // OK
                          TextButton(
                            onPressed: _isSubmitting ? null : _submitForm,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              minimumSize: const Size(60, 60),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}