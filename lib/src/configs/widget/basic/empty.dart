import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs.dart';
import '../../constants/app_space.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({super.key, this.title, this.content});
  final String? title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(AppImages.icEmpty),
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Paragraph(
                content: title,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          if (content != null)
            Paragraph(
              textAlign: TextAlign.center,
              content: content,
              style: STYLE_SMALL.copyWith(
                  fontSize: 16, color: AppColors.BLACK_400),
              // style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w700),
            )
        ],
      ),
    );
  }
}
