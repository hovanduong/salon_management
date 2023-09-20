import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key, 
    this.title, 
    this.fontWeightTitle, 
    this.content, 
    this.color,
    this.isSpaceBetween=false,
  });

  final String? title;
  final FontWeight? fontWeightTitle;
  final String? content;
  final Color?color;
  final bool isSpaceBetween;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: isSpaceBetween
        ? MainAxisAlignment.spaceBetween
        : MainAxisAlignment.start,
      children: [
        Paragraph(
          content: title!=null? '$title:': '',
          style: STYLE_MEDIUM.copyWith(
            fontWeight: fontWeightTitle,
          ),
        ),
        SizedBox(width: SpaceBox.sizeSmall,),
        Paragraph(
          content: content??'',
          style: STYLE_MEDIUM_BOLD.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}