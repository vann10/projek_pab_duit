import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCardFormWidget extends StatelessWidget {
  const AddCardFormWidget({super.key});

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
            child: Column(
              children: [
                TextFormField(
                  decoration: inputDecoration.copyWith(hintText: 'Nama Sumber'),
                  style: GoogleFonts.poppins(color: Colors.white),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: inputDecoration.copyWith(hintText: 'Saldo'),
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                const SizedBox(height: 15),
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextFormField(
                //         decoration: inputDecoration.copyWith(
                //           hintText: 'Expiry Date (MM/YY)',
                //         ),
                //         style: GoogleFonts.poppins(color: Colors.white),
                //       ),
                //     ),
                //     const SizedBox(width: 15),
                //     Expanded(
                //       child: TextFormField(
                //         decoration: inputDecoration.copyWith(
                //           hintText: 'Security Code',
                //         ),
                //         style: GoogleFonts.poppins(color: Colors.white),
                //         keyboardType: TextInputType.number,
                //         obscureText: true,
                //       ),
                //     ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              // Logika untuk menambahkan kartu
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF4e54c8),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
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
      //),
      //],
      //),
    );
  }
}
