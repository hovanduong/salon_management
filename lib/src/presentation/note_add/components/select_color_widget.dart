// ignore_for_file: cascade_invocations, parameter_assignments

import 'package:flutter/material.dart';

  List<Color> getNoteColors() {
    final colors = <Color>[];
    colors.add(getColorFromHex('#FFFFFF'));
    colors.add(getColorFromHex('#F28B82'));
    colors.add(getColorFromHex('#FBBC04'));
    colors.add(getColorFromHex('#FFF475'));
    colors.add(getColorFromHex('#CCFF90'));
    colors.add(getColorFromHex('#A7FFEB'));
    colors.add(getColorFromHex('#CBF0F8'));
    colors.add(getColorFromHex('#AECBFA'));
    colors.add(getColorFromHex('#D7AEFB'));
    colors.add(getColorFromHex('#E2CBB1'));
    colors.add(getColorFromHex('#2F4F4F'));
    colors.add(getColorFromHex('#CD5C5C'));
    colors.add(getColorFromHex('#B8860B'));
    colors.add(getColorFromHex('#2E8B57'));

    return colors;
  }

  Color getColorFromHex(String hexColor, {Color? defaultColor}) {
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

class SelectNoteColor extends StatelessWidget {
  final Function(Color)? onTap;

  const SelectNoteColor({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: getNoteColors().map((e) {
        return InkWell(
          onTap: () =>  onTap!(e),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: e,
                border: Border.all(color: Colors.grey.shade300)),
          ),
        );
      }).toList(),
    );
  }
}
