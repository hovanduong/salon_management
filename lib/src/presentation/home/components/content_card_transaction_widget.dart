
import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/language/homepage_language.dart';
import '../../../utils/app_currency.dart';

class ContentTransactionWidget extends StatelessWidget {
  const ContentTransactionWidget({
    super.key,
    this.isTitle=false, 
    this.nameService,
    this.date, 
    this.money, 
    this.color,
    this.isMoneyIncome=false,
  });

  final bool isTitle;
  final String? nameService;
  final String? date;
  final num? money;
  final Color? color;
  final bool isMoneyIncome;

  @override
  Widget build(BuildContext context) {
    var day;
    var month;
    var year;
    if(date!=null){
      year= date!.split('-')[0];
      month= date!.split('-')[1];
      day= date!.split('-')[2];
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color ?? AppColors.COLOR_WHITE,
        child: Paragraph(
          content: isTitle? day: nameService?.split('')[0],
          style: isTitle? STYLE_VERY_BIG.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.BLACK_500,
          ) : STYLE_MEDIUM.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ),
      title: Paragraph(
        content: nameService??'',
        style: STYLE_LARGE.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: isTitle? Paragraph(
        content: date!=null ?'${HomePageLanguage.month} $month, $year' : '',
        style: STYLE_LARGE.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ): null,
      trailing: Paragraph(
        content: isTitle? AppCurrencyFormat.formatMoney(money ?? '0') :
          isMoneyIncome ? '+${AppCurrencyFormat.formatMoney(money ?? '0')}'
          : '-${AppCurrencyFormat.formatMoney(money ?? '0')}',
        style: STYLE_LARGE.copyWith(
          fontWeight: FontWeight.w600,
          color:(money??0)>=0 && isMoneyIncome? 
            AppColors.Green_Money : AppColors.Red_Money,
        ),
      ),
    );
  }
}
