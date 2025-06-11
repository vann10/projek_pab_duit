import 'package:flutter/material.dart';
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
  String _description = '';
  String _category = 'Makanan';
  bool _isFlushbarShowing = false;
  final List<String> _categories = [
    'Makanan',
    'Transportasi',
    'Belanja',
    'Gaji',
    'Hiburan',
    'Lainnya',
  ];

  void _onNumberPress(String value) {
    final raw = _amount.replaceAll(',', '');

    if (raw.length >= 13) {
      if (!_isFlushbarShowing) {
        _isFlushbarShowing = true;

        Flushbar(
          message: "Maksimal input adalah 13 digit",
          duration: const Duration(seconds: 1),
          animationDuration: const Duration(microseconds: 6),
          flushbarStyle: FlushbarStyle.FLOATING,
          backgroundColor: Colors.redAccent,
          margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(Icons.warning, color: Colors.white),
        ).show(context).then((_) {
          _isFlushbarShowing = false;
        });
      }
      return;
    }

    final newRaw = raw + value;
    final number = int.tryParse(newRaw) ?? 0;

    setState(() {
      _amount = formatCurrency(number.toString());
    });
  }

  void _onBackspace() {
    setState(() {
      final raw = _amount.replaceAll(',', '');
      if (raw.isNotEmpty) {
        final newRaw = raw.substring(0, raw.length - 1);
        final number = int.tryParse(newRaw) ?? 0;
        _amount = newRaw.isEmpty ? '' : formatCurrency(number.toString());
      }
    });
  }

  String formatCurrency(String value) {
    if (value.isEmpty) return '0';
    final number = int.tryParse(value.replaceAll(',', '')) ?? 0;
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  Widget numButton(String value, {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        value,
        style: const TextStyle(fontSize: 28, color: Colors.white),
      ),
    );
  }

  void _submitForm() {
    debugPrint('Amount: $_amount');
    debugPrint('Description: $_description');
    debugPrint('Category: $_category');
    debugPrint('Type: ${_isExpense ? 'Expense' : 'Income'}');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    return Scaffold(
      backgroundColor: DarkColors.bg,
      resizeToAvoidBottomInset: false,
      // Add floating action button that's always visible
      floatingActionButton: isKeyboardVisible ? FloatingActionButton(
        onPressed: _submitForm,
        backgroundColor: DarkColors.oren,
        child: const Icon(Icons.check, color: Colors.white),
      ) : null,
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
                          horizontal: 16.0,
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
                            Row(
                              children: [
                                const Text(
                                  "Payment Method",
                                  style: TextStyle(color: Colors.white),
                                ),
                                // Add submit button in header when keyboard is visible
                                if (isKeyboardVisible) ...[
                                  const SizedBox(width: 16),
                                  TextButton(
                                    onPressed: _submitForm,
                                    child: const Text(
                                      'SAVE',
                                      style: TextStyle(
                                        color: DarkColors.oren,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
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
                                onTap: () => setState(() => _isExpense = false),
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
                                onTap: () => setState(() => _isExpense = true),
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

                      // Category Dropdown Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showDropdown = !_showDropdown;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 120),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              children: [
                                Text(
                                  _category.isEmpty ? "Category" : _category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          "${_isExpense ? '-' : '+'} Rp${_amount.isEmpty ? '0' : formatCurrency(_amount)}",
                          style: const TextStyle(
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
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Add Description",
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: DarkColors.oren),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: DarkColors.oren),
                            ),
                          ),
                          onChanged:
                              (value) => setState(() => _description = value),
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
                        ),
                        child: Column(
                          children:
                              _categories
                                  .map(
                                    (category) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          _category = category;
                                          _showDropdown = false;
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        child: Center(
                                          child: Text(
                                            category,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
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
                            onPressed: _submitForm,
                            child: const Text(
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