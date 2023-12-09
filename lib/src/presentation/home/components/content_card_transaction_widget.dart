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
        radius: isTitle ? 20 : 18,
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
          style: STYLE_MEDIUM.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: isTitle
          ? Paragraph(
              content:
                  date != null ? '$month/$year' : '',
              style: STYLE_MEDIUM.copyWith(
                // fontWeight: FontWeight.w00,
              ),
            )
          : null,
      trailing: Container(
        alignment: Alignment.centerRight,
        width: MediaQuery.sizeOf(context).width / 2.6,
        child: Paragraph(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          content: isTitle
              ? AppCurrencyFormat.formatMoneyD(money ?? 0)
              : isMoneyIncome
                  ? '+${AppCurrencyFormat.formatMoneyD(money ?? 0)}'
                  : '-${AppCurrencyFormat.formatMoneyD(money ?? 0)}',
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: (money ?? 0) >= 0 && isMoneyIncome
                ? AppColors.Green_Money
                : AppColors.Red_Money,
          ),
        ),
      ),
    );
  }
}
