import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/transaction_details.dart';
import '../../../configs/widget/widget.dart';

class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget({
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
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeBig),
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? AppColors.LINEAR_GREEN,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(BorderRadiusSize.sizeVeryBig),
          ),
        ),
        child: Paragraph(
          content: TransactionDetailsLanguage.downloadReceipt,
          textAlign: TextAlign.center,
          style: STYLE_LARGE.copyWith(
            color: colorContent ?? AppColors.LINEAR_GREEN,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
