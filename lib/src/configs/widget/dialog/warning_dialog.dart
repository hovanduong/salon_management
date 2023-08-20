import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs.dart';
import '../../constants/app_space.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({
    Key? key,
    this.content,
    this.image,
    this.title,
    this.leftButtonName,
    this.color,
    this.colorNameLeft,
    this.rightButtonName,
    this.onTapLeft,
    this.onTapRight,
  }) : super(key: key);
  final String? content;
  final String? title;
  final String? leftButtonName;
  final String? rightButtonName;
  final String? image;
  final Color? color;
  final Color? colorNameLeft;
  final Function()? onTapLeft;
  final Function()? onTapRight;

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
              style: STYLE_BIG.copyWith(fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeToPadding.sizeSmall,
                vertical: SizeToPadding.sizeLarge,
              ),
              child: Paragraph(
                textAlign: TextAlign.center,
                content: content ?? '',
                style: STYLE_MEDIUM,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5),
                    child: AppOutlineButton(
                      content: leftButtonName,
                      onTap: () => onTapLeft!(),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 15),
                    child: AppButton(
                      enableButton: true,
                      content: rightButtonName,
                      onTap: () => onTapRight!(),
                    ),
                  ),
                ),
              ],
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
