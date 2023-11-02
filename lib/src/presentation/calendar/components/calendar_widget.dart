// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';

import '../../../configs/constants/app_space.dart';
import '../../../configs/constants/constants.dart';
import '../../../configs/widget/widget.dart';
import '../../../resource/model/calendar_model.dart';
import '../../../utils/app_currency.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key, 
    this.listDay,
  });

  final List<CalendarModel>? listDay;

  @override
  Widget build(BuildContext context) {
    var day=0;
    return SingleChildScrollView(
      child: Table(
        border: const TableBorder(
          horizontalInside: BorderSide(color: AppColors.BLACK_200),
          verticalInside: BorderSide(color: AppColors.BLACK_200),
        ),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: AppColors.COLOR_WHITE),
            children: [
              buildTitleTop(content: 'T2', isTitle: true),
              buildTitleTop(content: 'T3', isTitle: true,),
              buildTitleTop(content: 'T4', isTitle: true,),
              buildTitleTop(content: 'T5', isTitle: true,),
              buildTitleTop(content: 'T6', isTitle: true,),
              buildTitleTop(content: 'T7', isTitle: true,),
              buildTitleTop(content: 'CN', isTitle: true,),
            ],
          ),
          ...List.generate( 5 , (index) {
            return TableRow(
              children: List.generate(7, (d) {
                  day++;
                  return buildTitleTop(
                    content: '${listDay![day-1].day}',
                    revenue: listDay?[day-1].revenue,
                    moneyPayment: listDay?[day-1].moneyPay,
                    isDayCurrent: listDay![day-1].isDayCurrent,
                  );
                }
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildTitleTop({String? content, bool isTitle = false, 
    num? revenue, num? moneyPayment, bool isDayCurrent=false,})
  {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeToPadding.sizeVeryVerySmall,
          horizontal: isTitle?0: SizeToPadding.sizeVeryVerySmall,
        ),
        color: isTitle? AppColors.PRIMARY_GREEN 
          : isDayCurrent? AppColors.COLOR_OLIVE.withOpacity(0.2) 
          :AppColors.COLOR_WHITE,
        child: Column(
          crossAxisAlignment: isTitle? CrossAxisAlignment.center 
          : CrossAxisAlignment.start,
          children: [
            Paragraph(
              content: content ?? '',
              style: STYLE_MEDIUM.copyWith(
                fontWeight: FontWeight.w600,
                color: isTitle ? AppColors.COLOR_WHITE : AppColors.BLACK_500,),
            ),
            if (revenue==null && moneyPayment==null) Container()
            else Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Paragraph(
                  content: AppCurrencyFormat.formatMoney(revenue),
                  color: AppColors.Green_Money,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Paragraph(
                  content: AppCurrencyFormat.formatMoney(moneyPayment),
                  color: AppColors.Red_Money,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
