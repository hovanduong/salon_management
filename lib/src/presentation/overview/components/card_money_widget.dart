// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class CardMoneyWidget extends StatelessWidget {
  const CardMoneyWidget({
    super.key, 
    this.iconShowTotalBalance=true,
    this.money, 
    this.onShowTotalBalance, 
    this.moneyIncome, 
    this.moneyExpenses,
  });

  final bool iconShowTotalBalance;
  final String? money;
  final String? moneyIncome;
  final String? moneyExpenses;
  final Function()? onShowTotalBalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
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
      contentLeft: Paragraph(
        content: moneyIncome ?? '',
        style: STYLE_LARGE_BIG.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.COLOR_WHITE,
        ),
      ),
      contentRight: Paragraph(
        content: moneyExpenses ?? '',
        style: STYLE_LARGE_BIG.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.COLOR_WHITE,
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
      contentRight: SvgPicture.asset(AppImages.icMore,
        width: 25, height: 25, color: AppColors.COLOR_WHITE,),
    );
  }
}
