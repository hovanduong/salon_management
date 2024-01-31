import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../utils/app_currency.dart';
import 'components.dart';

class FieldRevenueWidget extends StatelessWidget {
  const FieldRevenueWidget({super.key,
    this.totalRight, 
    this.totalLeft, 
    this.title, 
    this.money, 
    this.colorTitle, 
    this.keyPaid, 
    this.keyOwe, 
    this.descriptionPaid, 
    this.descriptionOwe, 
    this.totalPaid, 
    this.totalOwe, 
  });

  final num? totalRight;
  final num? totalLeft;
  final String? title;
  final num? money;
  final Color? colorTitle;
  final GlobalKey? keyPaid;
  final GlobalKey? keyOwe;
  final String? descriptionPaid;
  final String? descriptionOwe;
  final String? totalPaid;
  final String? totalOwe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeToPadding.sizeSmall,
          ),
          child: RichText(
            text: TextSpan(
              style: STYLE_MEDIUM.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.BLACK_500,
              ),
              children: [
                TextSpan(
                  text: '$title ',
                ),
                TextSpan(
                  text: AppCurrencyFormat.formatMoneyD(money??0),
                  style: STYLE_MEDIUM.copyWith(
                    color: colorTitle,  
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: SizeToPadding.sizeVerySmall,),
        Row(
          children: [
            Showcase(
              key: keyPaid??GlobalKey(),
              description: descriptionPaid,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width/2,
                child: CardServiceWidget(
                  title: totalPaid??'',
                  total: totalLeft!=null? AppCurrencyFormat.formatMoneyD(
                    totalLeft ?? 0,
                  ):'',
                  colorMoney: AppColors.Green_Money,
                ),
              ),
            ),
            Showcase(
              description: descriptionOwe,
              key: keyOwe??GlobalKey(),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width/2,
                child: CardServiceWidget(
                  title: totalOwe??'',
                  total: totalRight!=null?
                    AppCurrencyFormat.formatMoneyD(totalRight ?? 0,) : '',
                  colorMoney: AppColors.Red_Money,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
