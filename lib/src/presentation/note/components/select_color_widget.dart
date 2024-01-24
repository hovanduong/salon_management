// ignore_for_file: cascade_invocations, parameter_assignments

import 'package:flutter/material.dart';

import '../../../utils/app_handel_color.dart';

  List<Color> getNoteColors() {
    final colors = <Color>[];
    colors.add(AppHandleColor.getColorFromHex('#FFFFFF'));
    colors.add(AppHandleColor.getColorFromHex('#F28B82'));
    colors.add(AppHandleColor.getColorFromHex('#FBBC04'));
    colors.add(AppHandleColor.getColorFromHex('#FFF475'));
    colors.add(AppHandleColor.getColorFromHex('#CCFF90'));
    colors.add(AppHandleColor.getColorFromHex('#A7FFEB'));
    colors.add(AppHandleColor.getColorFromHex('#CBF0F8'));
    colors.add(AppHandleColor.getColorFromHex('#AECBFA'));
    colors.add(AppHandleColor.getColorFromHex('#D7AEFB'));
    colors.add(AppHandleColor.getColorFromHex('#E2CBB1'));
    colors.add(AppHandleColor.getColorFromHex('#2F4F4F'));
    colors.add(AppHandleColor.getColorFromHex('#CD5C5C'));
    colors.add(AppHandleColor.getColorFromHex('#B8860B'));
    colors.add(AppHandleColor.getColorFromHex('#2E8B57'));

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
          onTap: () =>  onTap!(e),
          child: Container(
            height: 50,
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
