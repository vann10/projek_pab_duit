import 'package:flutter/material.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:intl/intl.dart';

class DetailTransactionPage extends StatefulWidget {
  const DetailTransactionPage({super.key});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
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
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 30),

                _buildDetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TRANSACTION',
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

                _buildDetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CATEGORY',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Groceries',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: DarkColors.oren),
                        ],
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

                // Amount
                _buildDetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AMOUNT',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '₹235',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

                // Payment Method
                _buildDetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PAYMENT MENTHOD',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Physical Cash',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: DarkColors.oren),
                        ],
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

                // Description
                _buildDetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DESCRIPTION',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Weekly groceries',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
        border: BoxBorder.all(color: Color.fromARGB(132, 64, 204, 232)),
      ),
      child: child,
    );
  }
}
