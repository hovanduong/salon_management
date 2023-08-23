import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/statistics_language.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.arrow_back_ios_new),
          Paragraph(
            content: StatisticsLanguage.statistics,
            style: STYLE_MEDIUM_BOLD,
          ),
          Image.asset(AppImages.imageDowload), // chữ D viết hoa
        ],
      ),
    );
  }
}
