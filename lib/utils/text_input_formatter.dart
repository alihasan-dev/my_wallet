import 'package:flutter/services.dart';

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Empty is allowed (user clearing field)
    if (newValue.text.isEmpty) return newValue;
    // Reject if any character is not allowed
    if (!newValue.text.split('').every((c) => RegExp(r"[a-zA-Z0-9 '-]").hasMatch(c))) {
      return oldValue;
    }
    // Reject if it doesn't start with a letter
    if (!RegExp(r"^[a-zA-Z][a-zA-Z0-9 '-]*$").hasMatch(newValue.text)) {
      return oldValue;
    }
    return newValue;
  }
}

class IndianMobileNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove everything except digits.
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Empty input is allowed.
    if (digits.isEmpty) {
      return const TextEditingValue();
    }

    // First digit must be 6, 7, 8, or 9.
    if (!RegExp(r'^[6-9]').hasMatch(digits)) {
      return oldValue;
    }

    // Maximum 10 digits.
    final limitedDigits = digits.substring(
      0,
      digits.length > 10 ? 10 : digits.length,
    );

    final formatted = _format(limitedDigits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }

  String _format(String digits) {
    if (digits.length <= 4) {
      return digits;
    }

    if (digits.length <= 7) {
      return '${digits.substring(0, 4)}-'
          '${digits.substring(4)}';
    }

    return '${digits.substring(0, 4)}-'
        '${digits.substring(4, 7)}-'
        '${digits.substring(7)}';
  }
}