import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projek_pab_duit/db/database_helper.dart';
import 'package:projek_pab_duit/screens/home_page.dart';
import 'package:projek_pab_duit/screens/wallet_page.dart';

class AddCardFormWidget extends StatefulWidget {
  final VoidCallback onDompetAdded;

  const AddCardFormWidget({super.key, required this.onDompetAdded});

  @override
  State<AddCardFormWidget> createState() => _AddCardFormWidgetState();
}

class CurrencyInputFormatter extends TextInputFormatter {
  final String Function(int) formatFunction;

  CurrencyInputFormatter({required this.formatFunction});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Jika teks kosong, set ke "Rp0"
    if (newValue.text.isEmpty) {
      return TextEditingValue(
        text: formatFunction(0),
        selection: TextSelection.collapsed(offset: formatFunction(0).length),
      );
    }

    // Ambil bagian numerik saja (hapus semua karakter non-digit)
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Jika tidak ada digit setelah cleaning, set ke "0"
    if (digitsOnly.isEmpty) {
      return TextEditingValue(
        text: formatFunction(0),
        selection: TextSelection.collapsed(offset: formatFunction(0).length),
      );
    }

    // Hapus leading zeros kecuali jika hanya "0"
    if (digitsOnly.length > 1 && digitsOnly.startsWith('0')) {
      digitsOnly = digitsOnly.replaceFirst(RegExp(r'^0+'), '');
      if (digitsOnly.isEmpty) {
        digitsOnly = '0';
      }
    }

    // Convert ke int dan format menggunakan fungsi yang sudah ada
    int numericValue = int.tryParse(digitsOnly) ?? 0;
    String formattedText = formatFunction(numericValue);

    // Set cursor ke akhir text
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

// Helper function untuk mengambil nilai numerik dari formatted text
int getNumericValue(String formattedText) {
  String digitsOnly = formattedText.replaceAll(RegExp(r'[^\d]'), '');
  return int.tryParse(digitsOnly) ?? 0;
}

class _AddCardFormWidgetState extends State<AddCardFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _saldoController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize saldo controller dengan nilai kosong
    _saldoController.text = '';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _saldoController.dispose();
    super.dispose();
  }

  String formatRupiah(int amount, {String prefix = 'Rp'}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: prefix,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Future<void> _simpanDompet() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String nama = _namaController.text.trim();
        int saldo = getNumericValue(_saldoController.text);

        await DatabaseHelper.instance.addDompet(nama, saldo);

        _namaController.clear();
        _saldoController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dompet "$nama" berhasil ditambahkan!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menambah dompet: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: const Color(0xFF373758),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.poppins(color: Colors.white54),
    );

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF6C6CBB).withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Boxicons.bx_plus_circle,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                'Tambahkan Sumber',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _namaController,
                  decoration: inputDecoration.copyWith(hintText: 'Nama Sumber'),
                  style: GoogleFonts.poppins(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama sumber tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _saldoController,
                  decoration: inputDecoration.copyWith(hintText: 'Saldo'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    CurrencyInputFormatter(formatFunction: formatRupiah),
                  ],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value == null || getNumericValue(value) <= 0) {
                      return 'Saldo harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _isLoading ? null : _simpanDompet,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF4e54c8),
              minimumSize: const Size(double.infinity, 50),
              disabledBackgroundColor: const Color(0xFF4e54c8).withOpacity(0.6),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Add Card',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}