import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/debt_language.dart';
import '../../../utils/app_currency.dart';
import '../../../utils/date_format_utils.dart';

class BuildContentCardOwes extends StatelessWidget {
  const BuildContentCardOwes({super.key, 
    this.title, 
    this.money, 
    this.date,
    this.note,
    this.colorMoney, 
    this.nameCreator,
  });

  final String? title;
  final String? note;
  final num? money;
  final String? date;
  final Color? colorMoney;
  final String? nameCreator;

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
                content: AppCurrencyFormat.formatMoneyD(money??0),
                style: STYLE_MEDIUM.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorMoney,
                ),
              ),
            ],
          ),
          if (note!='') Padding(
            padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryVerySmall,),
            child: Row(
              children: [
                Paragraph(
                  content: '${DebtLanguage.note}: ',
                  style: STYLE_SMALL.copyWith(fontWeight: FontWeight.w500),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.sizeOf(context).width-122,
                  child: Paragraph(
                    content: note??'',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: STYLE_SMALL.copyWith(
                    ),
                  ),
                ),
              ],
            ),
          ) else const SizedBox(),
          SizedBox(height: SizeToPadding.sizeVeryVerySmall,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Paragraph(
                content: DebtLanguage.transactionOf,
                style: STYLE_SMALL.copyWith(fontWeight: FontWeight.w500),
              ),
              Paragraph(
                content: nameCreator ?? '',
                style: STYLE_SMALL.copyWith(fontWeight: FontWeight.w500,),
              ),
            ],
          ),
          SizedBox(height: SizeToPadding.sizeVerySmall,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Paragraph(
                content: DebtLanguage.date,
                style: STYLE_SMALL.copyWith(fontWeight: FontWeight.w500),
              ),
              Paragraph(
                content: date != null
                  ? AppDateUtils.splitHourDate(
                      AppDateUtils.formatDateLocal(
                        date!,
                      ),
                    )
                  : '',
                style: STYLE_SMALL.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
