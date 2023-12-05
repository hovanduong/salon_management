import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/language/homepage_language.dart';
import '../../../utils/app_currency.dart';

class ContentTransactionWidget extends StatelessWidget {
  const ContentTransactionWidget({
    super.key,
    this.isTitle = false,
    this.nameService,
    this.date,
    this.money,
    this.color,
    this.isMoneyIncome = false,
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
    if (date != null) {
      year = date!.split('-')[0];
      month = date!.split('-')[1];
      day = date!.split('-')[2];
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: color ?? AppColors.COLOR_WHITE,
        child: Paragraph(
          content: isTitle ? date?.split('-')[2] : nameService?.split('')[0],
          style: isTitle
              ? STYLE_VERY_BIG.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.BLACK_500,
                )
              : STYLE_MEDIUM.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.COLOR_WHITE,
                ),
        ),
      ),
      title: SizedBox(
        width: MediaQuery.sizeOf(context).width / 2.6,
        child: Paragraph(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          content: nameService ?? '',
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: isTitle
          ? Paragraph(
              content:
                  date != null ? '${HomePageLanguage.month} $month, $year' : '',
              style: STYLE_LARGEvafo.copyWith(
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      trailing: SizedBox(
        width: MediaQuery.sizeOf(context).width / 3.1,
        child: Paragraph(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          content: isTitle
              ? AppCurrencyFormat.formatMoneyVND(money ?? 0)
              : isMoneyIncome
                  ? '+${AppCurrencyFormat.formatMoneyVND(money ?? 0)}'
                  : '-${AppCurrencyFormat.formatMoneyVND(money ?? 0)}',
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w600,
            color: (money ?? 0) >= 0 && isMoneyIncome
                ? AppColors.Green_Money
                : AppColors.Red_Money,
          ),
        ),
      ),
    );
  }
}
