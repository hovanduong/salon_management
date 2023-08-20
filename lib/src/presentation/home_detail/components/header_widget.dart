import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, 
    this.content,  
    this.onTap,
  });
  final String? content;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => onTap!(),
          child: SvgPicture.asset(AppImages.icArrowLeft),),
        SizedBox(
          width: SpaceBox.sizeMedium * 2,
        ),
        Paragraph(
          content: content ?? '',
          style: STYLE_LARGE_BOLD,
        ),
      ],
    );
  }
}