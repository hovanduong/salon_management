import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../configs/configs.dart';
import '../../../../configs/constants/app_space.dart';
import 'cancel_button_widget.dart';
import 'confirm_button_widget.dart';


class WarningDialogWidget extends StatelessWidget {
  const WarningDialogWidget({
    Key? key,
    this.content,
    this.image,
    this.title,
    this.cancelButtonName,
    this.color,
    this.colorNameLeft,
    this.confirmButtonName,
    this.onTapLeft,
    this.onTapRight,
  }) : super(key: key);
  final String? content;
  final String? title;
  final String? cancelButtonName;
  final String? confirmButtonName;
  final String? image;
  final Color? color;
  final Color? colorNameLeft;
  final VoidCallback? onTapLeft;
  final VoidCallback? onTapRight;

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
              style: STYLE_BIG.copyWith(fontWeight: FontWeight.bold),

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
                    child: CancelButtonWidget(
                      content: cancelButtonName,
                      onTap: onTapLeft,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 15),
                    child: ConfirmButtonWidget(
                      // enableButton: true,
                      content: confirmButtonName,
                      onTap: onTapRight,
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
