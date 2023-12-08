import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../utils/app_currency.dart';
import '../../../utils/date_format_utils.dart';

class BuildContentCardOwes extends StatelessWidget {
  const BuildContentCardOwes({super.key, 
    this.title, 
    this.money, 
    this.date,
    this.colorMoney,
  });

  final String? title;
  final num? money;
  final String? date;
  final Color? colorMoney;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Paragraph(
                content: title??'',
                style: STYLE_MEDIUM.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Paragraph(
                content: AppCurrencyFormat.formatMoneyVND(money??0),
                style: STYLE_MEDIUM.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorMoney,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeToPadding.sizeVeryVerySmall,),
          Paragraph(
            content: date != null
              ? AppDateUtils.splitHourDate(
                  AppDateUtils.formatDateLocal(
                    date!,
                  ),
                )
              : '',
            style: STYLE_SMALL.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.BLACK_300,
            ),
          ),
        ],
      ),
    );
  }
}
