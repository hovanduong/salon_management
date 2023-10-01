import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import 'slidable_action_widget.dart';

class CardCustomerWidget extends StatelessWidget {
  const CardCustomerWidget({
    super.key, 
    this.onEdit,
    this.onDelete, 
    this.name, this.phone,
  });

  final Function(BuildContext context)? onEdit;
  final Function(BuildContext context)? onDelete;
  final String? name;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(
        bottom: SpaceBox.sizeSmall,
        right: SpaceBox.sizeMedium,
      ),
      child: SlidableActionWidget(
        isEdit: true,
        onTapButtonFirst: onDelete,
        onTapButtonSecond: onEdit,
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
              content: phone??'',
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
