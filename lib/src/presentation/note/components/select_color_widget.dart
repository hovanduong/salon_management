// ignore_for_file: cascade_invocations, parameter_assignments

import 'package:flutter/material.dart';

import '../../../utils/app_handel_color.dart';

List<Color> getNoteColors() {
  final colors = <Color>[];
  colors.add(AppHandleColor.getColorFromHex('#DAF6E3'));
  colors.add(AppHandleColor.getColorFromHex('#DBE9FC'));
  colors.add(AppHandleColor.getColorFromHex('#EFE9F6'));
  colors.add(AppHandleColor.getColorFromHex('#F7DEE3'));
  colors.add(AppHandleColor.getColorFromHex('#F7F6D4'));
  colors.add(AppHandleColor.getColorFromHex('#F3F3F3'));
  colors.add(AppHandleColor.getColorFromHex('#F5D8CE'));

  colors.add(AppHandleColor.getColorFromHex('#FFFFFF'));
  colors.add(AppHandleColor.getColorFromHex('#F28B82'));
  colors.add(AppHandleColor.getColorFromHex('#FBBC04'));
  colors.add(AppHandleColor.getColorFromHex('#FFF475'));
  colors.add(AppHandleColor.getColorFromHex('#CCFF90'));
  colors.add(AppHandleColor.getColorFromHex('#A7FFEB'));
  colors.add(AppHandleColor.getColorFromHex('#CBF0F8'));

  colors.add(AppHandleColor.getColorFromHex('#FAE0D0'));
  colors.add(AppHandleColor.getColorFromHex('#C3F7F4'));
  colors.add(AppHandleColor.getColorFromHex('#F8D0E1'));
  colors.add(AppHandleColor.getColorFromHex('#FFF0CC'));
  colors.add(AppHandleColor.getColorFromHex('#CAE6FF'));
  colors.add(AppHandleColor.getColorFromHex('#ECCDFF'));
  colors.add(AppHandleColor.getColorFromHex('#F59CA2'));

  colors.add(AppHandleColor.getColorFromHex('#AECBFA'));
  colors.add(AppHandleColor.getColorFromHex('#D7AEFB'));
  colors.add(AppHandleColor.getColorFromHex('#E2CBB1'));
  colors.add(AppHandleColor.getColorFromHex('#2F4F4F'));
  colors.add(AppHandleColor.getColorFromHex('#CD5C5C'));
  colors.add(AppHandleColor.getColorFromHex('#B8860B'));
  colors.add(AppHandleColor.getColorFromHex('#2E8B57'));

  colors.add(AppHandleColor.getColorFromHex('#B6F5F7'));
  colors.add(AppHandleColor.getColorFromHex('#EFCE89'));
  colors.add(AppHandleColor.getColorFromHex('#CDA7E6'));
  colors.add(AppHandleColor.getColorFromHex('#A2BEF4'));

  return colors;
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
          onTap: () => onTap!(e),
          child: Container(
            height: 50,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: e,
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        );
      }).toList(),
    );
  }
}
