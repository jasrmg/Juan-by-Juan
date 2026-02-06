// currency formatting util
// reusable functions for formatting money values
class CurrencyFormatter {
  // private constructor to prevent instantiation
  CurrencyFormatter._();

  // format centavos to php currency with thousand separators
  // 1050 -> 10.50, 100000 -> 1,000.00

  static String format(int centavos) {
    final amount = centavos / 100;
    final parts = amount.toStringAsFixed(2).split('.');

    final integerPart = parts[0];
    final decimalPart = parts[1];

    // add thousand separators
    final formattedInteger = integerPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return '₱$formattedInteger.$decimalPart';
  }
}
