import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../utils/app_currency.dart';
import 'slidable_action_widget.dart';

class CardServiceWidget extends StatelessWidget {
  const CardServiceWidget({
    super.key, 
    this.onTap, 
    this.name, this.money,
  });

  final Function(BuildContext context)? onTap;
  final String? name;
  final num? money;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(
        bottom: SpaceBox.sizeSmall,
        right: SpaceBox.sizeMedium,
      ),
      child: SlidableActionWidget(
        onTapButtonFirst: (context) => onTap!(context),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.COLOR_WHITE,
            borderRadius: BorderRadius.circular(SpaceBox.sizeSmall),
            boxShadow: [
              BoxShadow(
                color: AppColors.BLACK_300,
                blurRadius: SpaceBox.sizeVerySmall,
              ),
            ],
          ),
          child: ListTile(
            title: Paragraph(
              content: name?? '',
              style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
            ),
            subtitle: Paragraph(
              content: AppCurrencyFormat.formatMoneyVND(
                money ?? 0,
              ),
              style: STYLE_SMALL_BOLD.copyWith(
                color: AppColors.BLACK_400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}