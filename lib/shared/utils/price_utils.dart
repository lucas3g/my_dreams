import 'package:intl/intl.dart';

/// Utility functions for price manipulation.
class PriceUtils {
  /// Returns [price] with [amount] added to its numeric value.
  ///
  /// The currency prefix and decimal separator are preserved.
  static String addAmount(String price, double amount) {
    if (price.isEmpty) return '';

    final match = RegExp(r'([0-9.,]+)').firstMatch(price);
    if (match == null) return price;

    final prefix = price.substring(0, match.start);
    final suffix = price.substring(match.end);
    final digits = match.group(1)!;

    final usesComma = digits.contains(',') &&
        digits.lastIndexOf(',') > digits.lastIndexOf('.');
    final normalized = usesComma
        ? digits.replaceAll('.', '').replaceAll(',', '.')
        : digits.replaceAll(',', '');

    final value = double.tryParse(normalized);
    if (value == null) return price;

    final newValue = value + amount;
    var formatted = NumberFormat('0.00').format(newValue);
    if (usesComma) {
      formatted = formatted.replaceAll('.', ',');
    }

    return '$prefix$formatted$suffix';
  }
}
