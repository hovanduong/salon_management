import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import 'slidable_action_widget.dart';

class CardServiceWidget extends StatelessWidget {
  const CardServiceWidget({
    super.key, 
    this.onTapDelete, 
    this.name, this.money,
    this.onTapUpdate,
  });

  final Function(BuildContext context)? onTapDelete;
  final Function(BuildContext context)? onTapUpdate;
  final String? name;
  final num? money;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(
        top: SpaceBox.sizeSmall,
        right: SpaceBox.sizeSmall,
      ),
      child: SlidableActionWidget(
        isCheckCategory: true,
        onTapButtonFirst: (context) => onTapDelete!(context),
        onTapButtonSecond: (context) => onTapUpdate!(context),
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
            // subtitle: Paragraph(
            //   content: AppCurrencyFormat.formatMoneyVND(
            //     money ?? 0,
            //   ),
            //   style: STYLE_SMALL_BOLD.copyWith(
            //     color: AppColors.BLACK_400,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
