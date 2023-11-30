// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/homepage_language.dart';

class CardMoneyWidget extends StatelessWidget {
  const CardMoneyWidget({
    super.key, 
    this.iconShowTotalBalance=true,
    this.money, 
    this.onShowTotalBalance, 
    this.moneyIncome, 
    this.moneyExpenses, 
    this.context, 
    this.onShowMonth, 
    this.globalKey,
    this.isDate,
  });

  final bool iconShowTotalBalance;
  final String? money;
  final String? moneyIncome;
  final String? moneyExpenses;
  final Function()? onShowTotalBalance;
  final Function()? onShowMonth;
  final BuildContext? context;
  final GlobalKey? globalKey;
  final int ? isDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 200,
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_GREEN,
        borderRadius: BorderRadius.all(
          Radius.circular(BorderRadiusSize.sizeMedium),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleTotalBalance(),
          buildMoneyTotalBalance(),
          const Expanded(child: SizedBox()),
          buildTitleFluctuations(),
          SizedBox(height: SpaceBox.sizeSmall,),
          buildMoneyFluctuations(),
          SizedBox(height: SpaceBox.sizeSmall,),
        ],
      ),
    );
  }

  Widget buildMoneyFluctuations(){
    return buildRowBetween(
      contentLeft:Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.sizeOf(context!).width/2.6,
        child: Paragraph(
          content: moneyIncome ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: STYLE_LARGE_BIG.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ),
      contentRight: Container(
        alignment: Alignment.centerRight,
        width: MediaQuery.sizeOf(context!).width/2.6,
        child: Paragraph(
          content: moneyExpenses ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: STYLE_LARGE_BIG.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ),
    );
  }

  Widget buildTitleFluctuations(){
    return buildRowBetween(
      contentLeft: Row(
        children: [
          Image.asset(AppImages.arrowDownIcon,
            width: 20, height: 20, color: AppColors.COLOR_WHITE,),
          Paragraph(
            content: HomeLanguage.income,
            style: STYLE_LARGE.copyWith(
              color: AppColors.COLOR_WHITE,
            ),
          ),
        ],
      ),
      contentRight: Row(
        children: [
          Image.asset(AppImages.arrowUpIcon,
            width: 20, height: 20, color: AppColors.COLOR_WHITE,),
          Paragraph(
            content: HomeLanguage.expenses,
            style: STYLE_LARGE.copyWith(
              color: AppColors.COLOR_WHITE,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMoneyTotalBalance(){
    return iconShowTotalBalance? Paragraph(
      content: money?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: STYLE_VERY_BIG.copyWith(
        fontWeight: FontWeight.w800,
        color: AppColors.COLOR_WHITE,
      ),
    ): Container();
  }

  Widget buildRowBetween({Widget? contentLeft, Widget? contentRight}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        contentLeft ?? Container(),
        contentRight?? Container(),
      ],
    );
  }

  Widget buildTitleTotalBalance(){
    return buildRowBetween(
      contentLeft: InkWell(
        onTap: () => onShowTotalBalance!(),
        child: Row(
          children: [
            Paragraph(
              content: HomeLanguage.totalBalance,
              style: STYLE_LARGE.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.COLOR_WHITE,
              ),
            ),
            Icon(iconShowTotalBalance
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
              color: AppColors.COLOR_WHITE,
            ),
          ],
        ),
      ),
      contentRight:isDate==0? Showcase(
        description: HomePageLanguage.chooseMonth,
        key: globalKey?? GlobalKey(),
        child: InkWell(
          onTap: ()=> onShowMonth!(),
          child: SvgPicture.asset(AppImages.icMore,
            width: 25, height: 25, color: AppColors.COLOR_WHITE,),
        ),
      ): null,
    );
  }
}
