// ignore_for_file: prefer_null_aware_method_calls

import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/homepage_language.dart';

class TopWidget extends StatelessWidget {
  const TopWidget({
    super.key, 
    this.title, 
    this.widget,
    this.isShowTop=false,
    this.onTap,
  });

  final String? title;
  final Widget? widget;
  final bool isShowTop;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(onTap!=null){
          onTap!();
        }
      },
      child: Padding(
        padding: EdgeInsets.all( SizeToPadding.sizeVerySmall),
        child: Container(
          padding: EdgeInsets.all(SizeToPadding.sizeMedium),
          decoration: BoxDecoration(
            color: AppColors.COLOR_WHITE,
            borderRadius: BorderRadius.circular(
              BorderRadiusSize.sizeSmall,),
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
                  Paragraph(content: title ?? '',
                    style: STYLE_MEDIUM.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  widget ?? Icon(
                    isShowTop? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,),
                ],
              ),
              showTop(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitleTop({String? content, bool isTitle=false}){
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall,),
        child: Paragraph(
          content: content??'',
          style: STYLE_MEDIUM.copyWith(
            fontWeight: FontWeight.w600,
            color: isTitle? AppColors.PRIMARY_GREEN : AppColors.BLACK_500
          ),
        ),
      ),
    );
  }

  Widget showTop(){
    return isShowTop? Table(
      border: const TableBorder(
        horizontalInside: BorderSide(color: AppColors.BLACK_200),
      ),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: AppColors.COLOR_WHITE),
          children: [
            buildTitleTop(content: HomePageLanguage.top, isTitle: true),
            buildTitleTop(content: HomePageLanguage.nameService, isTitle: true),
            buildTitleTop(content: HomePageLanguage.revenue, isTitle: true),
          ],
        ),
        ...List.generate(
          5, (index) => TableRow(
            children: [
              buildTitleTop(content: '${index+1}'),
              buildTitleTop(content: 'ten dich vu'),
              buildTitleTop(content: 'doanh thu'),
            ]
          )
        )
      ],
    ) 
    : Container();
  }
}
