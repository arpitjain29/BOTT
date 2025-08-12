import 'package:flutter/services.dart';

class RangeInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  RangeInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.isEmpty) return newValue;

    final intValue = int.tryParse(text);
    if (intValue == null) return oldValue;

    if (text.length < 2) return newValue;

    if (intValue < min || intValue > max) {
      return oldValue;
    }
    return newValue;
  }
}