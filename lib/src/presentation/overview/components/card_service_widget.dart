import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class CardServiceWidget extends StatelessWidget {
  const CardServiceWidget({
    super.key, 
    this.title, 
    this.total, 
    this.money,
  });

  final String? title;
  final String? total;
  final String? money;

  @override
  Widget build(BuildContext context) {
    var growth='';
    if(money!.isNotEmpty || money != ''){
      growth= money!.split(' ')[1].split('')[1];
    }
    return Container(
      height: 130,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
              ),
            ),
          ),
          Row(
            children: [
              Icon(growth=='-'? Icons.arrow_downward
                : Icons.arrow_upward, 
                size: 18,
                color: growth=='-'? AppColors.PRIMARY_RED 
                : AppColors.PRIMARY_GREEN,),
              SizedBox(
                width: MediaQuery.of(context).size.width/3.2,
                child: Paragraph(content: money??'',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: STYLE_SMALL.copyWith(
                    fontWeight: FontWeight.w700,
                    color:growth=='-'? AppColors.PRIMARY_RED
                    : AppColors.PRIMARY_GREEN,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
