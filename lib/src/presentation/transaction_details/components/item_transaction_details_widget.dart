import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ItemTransactionDetailsWidget extends StatelessWidget {
  const ItemTransactionDetailsWidget({
    super.key,
    this.title,
    this.colorContent,
    this.content,
    this.textStyle,
  });
  final String? title;
  final String? content;
  final Color? colorContent;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeVeryBig,
        vertical: SizeToPadding.sizeVerySmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(content: title ?? ''),
          Paragraph(
            content: content ?? '',
            style: textStyle ??
                STYLE_MEDIUM_BOLD.copyWith(
                  color: colorContent ?? AppColors.BLACK_500,
                ),
          )
        ],
      ),
    );
  }
}
