import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs.dart';
import '../../constants/app_space.dart';

class CustomerAppBar extends StatelessWidget {
  const CustomerAppBar({
    super.key,
    this.title,
    this.icon,
    this.widget,
    this.onTap,
    this.rightIcon,
    this.gestureDetector,
  });
  final String? title;
  final String? icon;
  final Widget? widget;
  final VoidCallback? onTap;
  final IconButton? rightIcon;
  final GestureDetector? gestureDetector;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: SvgPicture.asset(icon ?? AppImages.icArrowLeft),
        ),

        SizedBox(
          width: SpaceBox.sizeMedium * 2,
        ),
        Paragraph(
          content: title ?? '',
          style: STYLE_LARGE.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        widget ?? const SizedBox(),
        SizedBox(child: rightIcon),
        SizedBox(child: gestureDetector),
      ],
    );
  }
}
