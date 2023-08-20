import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_space.dart';
import '../../constants/app_styles.dart';
import '../button/app_button.dart';
import '../text/paragraph.dart';

class WarningOneDialog extends StatelessWidget {
  const WarningOneDialog({
    Key? key,
    this.content,
    this.image,
    this.title,
    this.buttonName,
    this.color,
    this.colorNameLeft,
    this.onTap,
  }) : super(key: key);
  final String? content;
  final String? title;
  final String? buttonName;
  final String? image;
  final Color? color;
  final Color? colorNameLeft;
  final Function()? onTap;

  dynamic dialogContent(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.COLOR_WHITE,
              radius: 35,
              child: SvgPicture.asset(
                image ?? '',
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Paragraph(
              content: title,
              style: STYLE_BIG.copyWith(fontWeight: FontWeight.w500),
            ),
            if (content != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeToPadding.sizeSmall,
                  vertical: SizeToPadding.sizeLarge,
                ),
                child: Paragraph(
                  content: content ?? '',
                ),
              ),
            if (buttonName != null) const SizedBox(height: 10),
            if (buttonName != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: AppButton(
                  enableButton: true,
                  content: buttonName,
                  onTap: () => onTap!(),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
