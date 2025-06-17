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
  String _description = '-';
  bool _isFlushbarShowing = false;
  bool _isSubmitting = false;

  // Controller untuk deskripsi
  late TextEditingController _descriptionController;

  // --- State untuk Kategori ---
  List<String> _kategoriItems = [];
  String? _selectedKategori;
  bool _showKategoriDropdown = false;

  // --- State BARU untuk Dompet ---
  List<Map<String, dynamic>> _dompetList = [];
  String? _selectedDompetName;
  int? _selectedDompetId;
  bool _showDompetDropdown = false;

  // Mengambil data kategori berdasarkan tipe (INCOME/EXPENSE)
  Future<void> _loadKategoriItems() async {
    List<String> items = [];
    final tipe = _isExpense ? "EXPENSE" : "INCOME";
    final kategoriList = await DatabaseHelper.instance.getKategoriByTipe(tipe);
    items = kategoriList.map((row) => row['nama'] as String).toList();

    setState(() {
      _kategoriItems = items;
      if (items.isNotEmpty) {
        _selectedKategori = items.first;
      } else {
        _selectedKategori = null;
      }
    });
  }

  // --- Fungsi BARU untuk mengambil data Dompet ---
  Future<void> _fetchDompet() async {
    final dompetData = await DatabaseHelper.instance.getAllDompet();
    setState(() {
      _dompetList = dompetData;
      // Atur dompet pertama sebagai default jika ada
      if (_dompetList.isNotEmpty) {
        _selectedDompetId = _dompetList.first['id'];
        _selectedDompetName = _dompetList.first['nama'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _loadKategoriItems(); // Memuat kategori
    _fetchDompet(); // Memuat dompet
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onNumberPress(String value) {
    final raw = _amount.replaceAll(',', '');

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

  String _formatCurrency(int value) {
    if (value == 0) return '';
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }

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
    if (_isSubmitting) return;

    final jumlah = _getRawAmount();
    final description = _descriptionController.text.trim();

    if (jumlah <= 0) {
      _showMessage("Masukkan jumlah yang valid", isError: true);
      return;
    }

    // --- VALIDASI KATEGORI DAN DOMPET ---
    if (_selectedKategori == null) {
      _showMessage("Pilih kategori terlebih dahulu", isError: true);
      return;
    }
    if (_selectedDompetId == null) {
      _showMessage("Pilih dompet terlebih dahulu", isError: true);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // --- MODIFIKASI: Kirim `dompetId` yang dipilih ---
      final success = await DatabaseHelper.instance
          .insertTransaksiWithUpdateSaldo(
            jumlah: jumlah,
            kategori: _selectedKategori!,
            deskripsi:
                description.isEmpty
                    ? '-'
                    : description, // default value jika kosong
            tipe: _isExpense ? 'EXPENSE' : 'INCOME',
            dompetId: _selectedDompetId!, // Menggunakan ID dompet yang dipilih
          );

      if (success) {
        _showMessage(
          "${_isExpense ? 'Pengeluaran' : 'Pemasukan'} berhasil disimpan!",
        );
        await Future.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (Route<dynamic> route) => false,
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

  void _onDescriptionChanged(String value) {
    setState(() {
      _description = value;
    });
  }

  // --- Widget BARU untuk Pemilih Dompet ---
  Widget _buildDompetSelector() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showDompetDropdown = !_showDompetDropdown;
          _showKategoriDropdown = false; // Tutup dropdown lain
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: DarkColors.oren),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: DarkColors.oren),
                const SizedBox(width: 12),
                Text(
                  _selectedDompetName ?? "Pilih Dompet",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            Icon(
              _showDompetDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaHeight =
        MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - safeAreaHeight;

    // Hitung tinggi numpad (320px untuk 4 baris numpad + padding)
    const numpadHeight = 320.0;

    return Scaffold(
      backgroundColor: DarkColors.bg,
      resizeToAvoidBottomInset: false,
      floatingActionButton:
          isKeyboardVisible
              ? FloatingActionButton(
                onPressed: _isSubmitting ? null : _submitForm,
                backgroundColor: _isSubmitting ? Colors.grey : DarkColors.oren,
                child:
                    _isSubmitting
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
                                  if (!_isExpense) return;
                                  setState(() => _isExpense = false);
                                  await _loadKategoriItems();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        !_isExpense
                                            ? Colors.green
                                            : Colors.transparent,
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
                                  if (_isExpense) return;
                                  setState(() => _isExpense = true);
                                  await _loadKategoriItems();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _isExpense
                                            ? Colors.red
                                            : Colors.transparent,
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showKategoriDropdown = !_showKategoriDropdown;
                            _showDompetDropdown = false; // Tutup dropdown lain
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
                                    _selectedKategori ?? 'Pilih Kategori',
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
                                  _showKategoriDropdown
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _descriptionController,
                          style: const TextStyle(color: Colors.white),
                          maxLength: 100,
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

                      // --- Widget Pemilih Dompet DITEMPATKAN DI SINI ---
                      _buildDompetSelector(),
                    ],
                  ),

                  // Dropdown overlay untuk Kategori
                  if (_showKategoriDropdown)
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
                              children:
                                  _kategoriItems
                                      .map(
                                        (item) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedKategori = item;
                                              _showKategoriDropdown = false;
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                              vertical:
                                                  _kategoriItems.length > 5
                                                      ? 10
                                                      : 12,
                                              horizontal: 16,
                                            ),
                                            constraints: const BoxConstraints(
                                              minHeight: 40,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  _selectedKategori == item
                                                      ? Colors.white
                                                          .withOpacity(0.2)
                                                      : Colors.transparent,
                                            ),
                                            child: Center(
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  color:
                                                      _selectedKategori == item
                                                          ? Colors.white
                                                          : Colors.white70,
                                                  fontWeight:
                                                      _selectedKategori == item
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                  fontSize:
                                                      _kategoriItems.length > 7
                                                          ? 14
                                                          : 16,
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

                  // --- DROPDOWN OVERLAY DOMPET YANG DIPERBAIKI ---
                  if (_showDompetDropdown)
                    Positioned(
                      top: 415, // Posisi tetap di bawah selector dompet
                      left: 16,
                      right: 16,
                      child: Material(
                        elevation: 8, // Memberikan elevasi tinggi
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 43, 44, 61),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: DarkColors.oren),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.7),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    _dompetList.map((dompet) {
                                      final itemNama = dompet['nama'] as String;
                                      final itemId = dompet['id'] as int;
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedDompetId = itemId;
                                            _selectedDompetName = itemNama;
                                            _showDompetDropdown = false;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                _selectedDompetId == itemId
                                                    ? DarkColors.oren
                                                        .withOpacity(0.3)
                                                    : Colors.transparent,
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.account_balance_wallet,
                                                color:
                                                    _selectedDompetId == itemId
                                                        ? DarkColors.oren
                                                        : Colors.white70,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  itemNama,
                                                  style: TextStyle(
                                                    color:
                                                        _selectedDompetId ==
                                                                itemId
                                                            ? DarkColors.oren
                                                            : Colors.white,
                                                    fontWeight:
                                                        _selectedDompetId ==
                                                                itemId
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              if (_selectedDompetId == itemId)
                                                Icon(
                                                  Icons.check,
                                                  color: DarkColors.oren,
                                                  size: 20,
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!isKeyboardVisible)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    for (var i = 0; i < 3; i++)
                      SizedBox(
                        height: _showDompetDropdown ? 0 : 80,
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
                          numButton('0', onPressed: () => _onNumberPress('0')),
                          TextButton(
                            onPressed: _isSubmitting ? null : _submitForm,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              minimumSize: const Size(60, 60),
                            ),
                            child:
                                _isSubmitting
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
