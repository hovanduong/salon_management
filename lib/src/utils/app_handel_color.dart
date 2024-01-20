import 'package:flutter/material.dart';

class AppHandleColor {
  static Color getColorFromHex(String hexColor, {Color? defaultColor}) {
    if (hexColor.isEmpty || hexColor==null) {
      if (defaultColor != null) {
        return defaultColor;
      } else {
        throw ArgumentError('Can not parse provided hex $hexColor');
      }
    }

    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
