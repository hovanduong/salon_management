import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class StatusService extends StatelessWidget {
  const StatusService({super.key, this.color, this.content});

  final Color? color;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: SpaceBox.sizeBig*5,
      height: SpaceBox.sizeMedium*2.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpaceBox.sizeVerySmall),
        color: color,
      ),
      child: Paragraph(
        content: content ?? '',
        style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.COLOR_WHITE),
      ),
    );
  }
}
