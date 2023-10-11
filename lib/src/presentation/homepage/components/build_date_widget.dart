import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class BuildDateWidget extends StatelessWidget {
  const BuildDateWidget({
    super.key, 
    this.date,
  });
  final String? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        border: Border.all(color: AppColors.BLACK_200),
        boxShadow: [
          BoxShadow(
            blurRadius: SpaceBox.sizeMedium,
            color: AppColors.BLACK_200,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(
            content: date??'',
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(Icons.calendar_month, size: 30,),
        ],
      ),
    );
  }
}
