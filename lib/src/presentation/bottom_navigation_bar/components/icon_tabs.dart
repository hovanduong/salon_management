// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconTabWidget extends StatelessWidget {
  const IconTabWidget({Key? key, this.name, this.color, this.size, this.onTap})
      : super(key: key);
  final String? name;
  final Color? color;
  final double? size;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: SvgPicture.asset(
          name ?? '',
          color: color,
          height: size ?? 30,
        ),
      ),
    );
  }
}
