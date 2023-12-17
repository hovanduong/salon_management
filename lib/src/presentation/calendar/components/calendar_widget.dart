// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../configs/constants/app_space.dart';
import '../../../configs/constants/constants.dart';
import '../../../configs/widget/widget.dart';
import '../../../resource/model/model.dart';
import '../../../resource/model/revenue_day_model.dart';
import '../../../utils/app_currency.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key, 
    this.listDay,
    this.isWeekend=false,
    this.onShowRevenueDay,
  });

  final List<ReportModel>? listDay;
  final bool isWeekend;
  final Function(String? date)? onShowRevenueDay;

  @override
  Widget build(BuildContext context) {
    var day=0;
    return SingleChildScrollView(
      child: (listDay!.isNotEmpty && (listDay?.length ?? 0) >=28)? Table(
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
          ...List.generate(isWeekend ? 6 : 5, (index) {
            return TableRow(
              children: List.generate(7, (d) {
                  day++;
                  return buildTitleTop(
                    content: listDay?[day-1].date ?? '',
                    revenueDay: listDay?[day-1].revenueDay,
                    isCurrentDay: listDay![day-1].isCurrentDay,
                  );
                }
              ),
            );
          }),
        ],
      ) : Container(),
    );
  }

  Widget buildTitleTop({String? content, bool isTitle = false, 
    List<RevenueDayModel>? revenueDay, bool isCurrentDay=false,})
  {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: InkWell(
        onTap: () {
          if(isTitle==false){
            onShowRevenueDay!(content);
          }
        },
        child: Container(
          height: isTitle? 45 : 80,
          padding: EdgeInsets.symmetric(
            vertical: SizeToPadding.sizeVerySmall,
            horizontal: isTitle?0: SizeToPadding.sizeVeryVerySmall,
          ),
          decoration: BoxDecoration(
            color: isTitle? AppColors.PRIMARY_GREEN 
              : isCurrentDay? AppColors.COLOR_OLIVE.withOpacity(0.2) 
              :AppColors.COLOR_WHITE,
          ),
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
              const Expanded(child: SizedBox()),
              if (revenueDay==[] || revenueDay==null) Container()
              else Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(revenueDay.length, 
                  (index) => Paragraph(
                    content: AppCurrencyFormat.formatMoney(
                      revenueDay[index].money ?? 0,
                    ),
                    style: STYLE_VERY_SMALL.copyWith(
                      color: (revenueDay[index].income ?? false)
                        ? AppColors.Green_Money
                        : AppColors.Red_Money,
                      fontSize: 9,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
