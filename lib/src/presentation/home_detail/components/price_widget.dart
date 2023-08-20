import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({super.key, this.price});

  final String? price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: SpaceBox.sizeMedium),
      padding: EdgeInsets.symmetric(
        horizontal: SpaceBox.sizeSmall,
        vertical: 3,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.PRIMARY_PINK, AppColors.SECONDARY_PINK],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Paragraph(
        content: price != null ? '$price VNĐ' : '', 
        style: STYLE_VERY_SMALL_BOLE.copyWith(
          color: AppColors.COLOR_WHITE,
        ),
      ),
    );
  }
}
