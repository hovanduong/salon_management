import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    this.title,
    this.fontWeightTitle,
    this.content,
    this.color,
    this.isSpaceBetween = false,
    this.fontWeightContent,
  });

  final String? title;
  final FontWeight? fontWeightTitle;
  final String? content;
  final Color? color;
  final bool isSpaceBetween;
  final FontWeight? fontWeightContent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isSpaceBetween
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: [
        Paragraph(
          content: title ?? '',
          style: STYLE_MEDIUM.copyWith(
            fontWeight: fontWeightTitle,
          ),
        ),
        SizedBox(
          width: SpaceBox.sizeSmall,
        ),
        Paragraph(
          content: content ?? '',
          style: STYLE_MEDIUM.copyWith(
              color: color, fontWeight: fontWeightContent,),
        ),
      ],
    );
  }
}
