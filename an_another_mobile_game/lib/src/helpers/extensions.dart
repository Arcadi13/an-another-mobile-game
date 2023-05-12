import 'package:intl/intl.dart';

extension FormatCurrency on int {
  String formatCurrency() {
    return NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 1)
        .format(this);
  }

  String formatNumber() {
    return NumberFormat.compact().format(this);
  }
}
