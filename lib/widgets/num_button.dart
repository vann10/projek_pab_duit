
import 'package:flutter/material.dart';

Widget numButton(BuildContext context, int number, {VoidCallback? onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      '$number',
      style: const TextStyle(fontSize: 28, color: Colors.white),
    ),
  );
}
