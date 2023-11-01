import 'package:flutter/cupertino.dart';

import '../../../configs/constants/app_space.dart';
import '../../../configs/constants/constants.dart';
import '../../../configs/widget/widget.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key, 
    this.listDay,
  });

  final List<int>? listDay;

  @override
  Widget build(BuildContext context) {
    var day=0;
    return Table(
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
                  content: '${listDay![day-1]}',
                  revenue: '200.000',
                  moneyPayment: '3.000.000',
                );
              }
            ),
          );
        }),
      ],
    );
  }

  Widget buildTitleTop({String? content, bool isTitle = false, 
    String? revenue, String? moneyPayment,})
  {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeToPadding.sizeVeryVerySmall,
          horizontal: isTitle?0: SizeToPadding.sizeVeryVerySmall,
        ),
        color: isTitle? AppColors.PRIMARY_GREEN 
          : AppColors.COLOR_WHITE,
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
            if (revenue==null) Container()
            else Column(
              children: [
                Paragraph(
                  content: revenue,
                  textAlign: TextAlign.center,
                  color: AppColors.Green_Money,
                ),
                Paragraph(
                  content: moneyPayment,
                  color: AppColors.Red_Money,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
