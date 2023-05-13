import 'package:intl/intl.dart';

extension IntExtensions on int {
  String formatCurrency() {
    return NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 1)
        .format(this);
  }

  String formatNumber() {
    return NumberFormat.compact().format(this);
  }
}

extension StringExtensions on String {
  String format(List<String> parameters) {
    String result = this;

    for (int i = 0; i < parameters.length; i++) {
      result = result.replaceAll('{$i}', parameters[i]);
    }

    return result;
  }
}
