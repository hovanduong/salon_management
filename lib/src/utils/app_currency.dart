import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppCurrencyFormat {
  static String formatMoneyDot(num value, {bool isDecimal = false}) {
    if (isDecimal) return NumberFormat('###,###,###.##', 'en_us').format(value)
      .replaceAll(RegExp('[.]'), ',s');

    return NumberFormat('###,###,###', 'en_us')
        .format(value);
  }

  static String formatMoneyVND(num value) {
    final money = '${formatMoneyDot(value)} VNĐ';
    return money;
  }

  static String formatMoney(dynamic money) {
    return NumberFormat('###,###,###', 'en_us').format(money);
  }

  static String formatLoyalty(double point) {
    return NumberFormat('###,###,###', 'en_us')
        .format(point)
        .replaceAll(RegExp('[,]'), '.');
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat('#,###');
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}
