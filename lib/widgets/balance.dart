import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projek_pab_duit/db/database_helper.dart';

Widget balance() {
  return FutureBuilder<int>(
    future: DatabaseHelper.instance.getTotalSaldo(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        final total = snapshot.data ?? 0;

        // Formatter angka dengan titik
        final formattedSaldo = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp',
          decimalDigits: 0,
        ).format(total);

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Available Balance",
                style: GoogleFonts.dmSans(color: Colors.green, fontSize: 20),
              ),
              Text(
                formattedSaldo,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              //Image.asset('assets/images/percentage.png', width: 360),
            ],
          ),
        );
      }
    },
  );
}
