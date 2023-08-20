import 'package:flutter/material.dart';

import '../../../../configs/configs.dart';
import '../../../../configs/constants/app_space.dart';

class CancelButtonWidget extends StatelessWidget {
  const CancelButtonWidget({
    super.key,
    this.color,
    this.onTap,
    this.content,
    this.colorContent,
  });
  final Color? color;
  final VoidCallback? onTap;
  final String? content;
  final Color? colorContent;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? AppColors.PRIMARY_PINK,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(BorderRadiusSize.sizeSmall),
          ),
        ),
        child: Paragraph(
          content: content,
          textAlign: TextAlign.center,
          style: STYLE_MEDIUM.copyWith(
            color: colorContent ?? AppColors.PRIMARY_PINK,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
