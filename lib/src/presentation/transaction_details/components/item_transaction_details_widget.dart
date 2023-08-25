import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ItemTransactionDetailsWidget extends StatelessWidget {
  const ItemTransactionDetailsWidget(
      {super.key,
      this.title,
      this.colorContent,
      this.colorTitle,
      this.content,
      this.textStyleTitle,
      this.textStyleContent});
  final String? title;
  final String? content;
  final Color? colorContent;
  final Color? colorTitle;
  final TextStyle? textStyleTitle;
  final TextStyle? textStyleContent;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeVeryBig,
        vertical: SizeToPadding.sizeVeryVerySmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(
            content: title ?? '',
            style: textStyleTitle ??
                STYLE_MEDIUM_BOLD.copyWith(
                  color: colorContent ?? AppColors.COLOR_GREY,
                ),
          ),
          Paragraph(
            content: content ?? '',
            style: textStyleContent ??
                STYLE_MEDIUM_BOLD.copyWith(
                  color: colorContent ?? AppColors.BLACK_500,
                ),
          )
        ],
      ),
    );
  }
}
