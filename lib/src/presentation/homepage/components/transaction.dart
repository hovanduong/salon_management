import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key, 
    this.image='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmVfPm6hKZTky6SpTNvEZqaqa8frwh_4Y2Mj4ERoDp0ammsl4LYgjM3VJHBjITmADt8lg&usqp=CAU',
    this.title, this.subtile, this.money,
  });

  final String image;
  final String? title;
  final String? subtile;
  final String? money;

  @override
  Widget build(BuildContext context) {
    var isColor = '+';
    if(money!=null){
      isColor= money!.split(' ')[0];
    }
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                image,
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Paragraph(
                    content: title ?? '',
                    style: STYLE_LARGE_BOLD.copyWith(
                      color: AppColors.BLACK_500,
                    ),
                  ),
                  Paragraph(
                    content: subtile ?? '',
                    style: STYLE_MEDIUM.copyWith(
                      color: AppColors.COLOR_GREY,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Paragraph(
            content: money ?? '',
            style: STYLE_LARGE_BOLD.copyWith(
              color: isColor == '+' 
                ?AppColors.FIELD_GREEN 
                :AppColors.PRIMARY_RED,
            ),
          ),
        ],
      ),
    );
  }
}