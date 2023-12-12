import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class CardServiceWidget extends StatelessWidget {
  const CardServiceWidget({
    super.key, 
    this.title, 
    this.total, 
    this.colorMoney,
  });

  final String? title;
  final String? total;
  final Color? colorMoney;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.all(SizeToPadding.sizeVeryVerySmall),
      padding: EdgeInsets.all(SizeToPadding.sizeSmall),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        borderRadius: BorderRadius.all(Radius.circular(SpaceBox.sizeSmall)),
        boxShadow: [
          BoxShadow(blurRadius: SpaceBox.sizeMedium, color: AppColors.BLACK_200) 
        ,],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Paragraph(content: title??'',
            // maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeToPadding.sizeVeryVerySmall,),
            child: Paragraph(content: total??'',
              style: STYLE_LARGE.copyWith(
                fontWeight: FontWeight.w500,
                color: colorMoney,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
