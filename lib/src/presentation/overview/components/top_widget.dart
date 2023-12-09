// ignore_for_file: prefer_null_aware_method_calls

import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/homepage_language.dart';
import '../../../resource/model/model.dart';
import '../../../utils/app_currency.dart';

class TopWidget extends StatelessWidget {
  const TopWidget({
    super.key,
    this.title,
    this.widget,
    this.isShowTop = false,
    this.onTap,
    this.topService,
  });

  final String? title;
  final Widget? widget;
  final bool isShowTop;
  final Function()? onTap;
  final List<DataTopService>? topService;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.all(SizeToPadding.sizeMedium),
        decoration: BoxDecoration(
          color: AppColors.COLOR_WHITE,
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.sizeSmall,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: SpaceBox.sizeMedium,
              color: AppColors.BLACK_200,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Paragraph(
                  content: title ?? '',
                  style: STYLE_MEDIUM.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                widget ??
                    Icon(
                      isShowTop
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
              ],
            ),
            showTop(),
          ],
        ),
      ),
    );
  }

  Widget buildTitleTop({String? content, bool isTitle = false}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeToPadding.sizeSmall,
        ),
        child: Paragraph(
          content: content ?? '',
          textAlign: TextAlign.center,
          style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
              color: isTitle ? AppColors.PRIMARY_GREEN : AppColors.BLACK_500,),
        ),
      ),
    );
  }

  Widget showTop() {
    return isShowTop
      ? topService!.isEmpty
      ? Padding(
        padding: EdgeInsets.only(top: SizeToPadding.sizeBig),
        child: EmptyDataWidget(
          title: HomeLanguage.emptyTopService,
          content: HomeLanguage.contentEmptyTopService,
        ),
      ): Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(4),
            2: FlexColumnWidth(3),
            3: FlexColumnWidth(4),
          }, 
          border: const TableBorder(
            horizontalInside: BorderSide(color: AppColors.BLACK_200),
          ),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: AppColors.COLOR_WHITE),
              children: [
                buildTitleTop(content: HomePageLanguage.stt, isTitle: true),
                buildTitleTop(
                    content: HomePageLanguage.nameService, isTitle: true,),
                buildTitleTop(
                    content: HomePageLanguage.quantity, isTitle: true,),
                buildTitleTop(
                    content: HomePageLanguage.revenue, isTitle: true,),
              ],
            ),
            ...List.generate(topService?.length ?? 0, (index) {
              final revenue = topService?[index].revenue ?? 0;
              return TableRow(
                children: [
                  buildTitleTop(content: '${index + 1}'),
                  buildTitleTop(content: topService?[index].nameService),
                  buildTitleTop(
                    content: topService?[index].quantity.toString(),),
                  buildTitleTop(
                      content: AppCurrencyFormat.formatMoneyD(revenue),),
                ],
              );
            }),
          ],
        )
      : Container();
  }
}
