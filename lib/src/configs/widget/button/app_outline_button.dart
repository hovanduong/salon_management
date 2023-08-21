import 'package:flutter/material.dart';

import '../../configs.dart';
import '../../constants/app_space.dart';

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    super.key,
    this.color,
    this.onTap,
    this.content,
    this.colorContent,
  });
  final Color? color;
  final Function()? onTap;
  final String? content;
  final Color? colorContent;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? AppColors.LINEAR_GREEN,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(BorderRadiusSize.sizeSmall),
          ),
        ),
        child: Paragraph(
          content: content,
          textAlign: TextAlign.center,
          style: STYLE_MEDIUM.copyWith(
            color: colorContent ?? AppColors.LINEAR_GREEN,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
