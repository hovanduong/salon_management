import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, this.titleLeft, this.titleRight});

  final String? titleLeft;
  final String? titleRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SpaceBox.sizeMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(
            content: titleLeft ?? '',
            style: STYLE_LARGE_BOLD.copyWith(
              color: AppColors.BLACK_500,
            ),
          ),
          Paragraph(
            content: titleRight ?? '',
            style: STYLE_MEDIUM.copyWith(
              color: AppColors.COLOR_GREY,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}