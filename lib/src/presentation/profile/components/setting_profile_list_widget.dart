// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class SettingProfileListWidget extends StatelessWidget {
  const SettingProfileListWidget({
    super.key,
    this.image,
    this.colorTitle,
    this.title,
    this.textStyleTitle,
    this.colorImage,
    this.onTap,
    this.isOntap = false,
  });
  final String? image;
  final Color? colorImage;
  final Color? colorTitle;
  final TextStyle? textStyleTitle;
  final String? title;
  final Function()? onTap;
  final bool isOntap;
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        onTap!();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeToPadding.sizeVeryBig,
          vertical: SizeToPadding.sizeSmall / 1.1,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (image != null)
                  SvgPicture.asset(
                    image!,
                    color: colorImage,
                  ),
                SizedBox(
                  width: SpaceBox.sizeMedium,
                ),
                Paragraph(
                  content: title ?? '',
                  style: textStyleTitle ??
                      STYLE_LARGE_BOLD.copyWith(
                        color: colorTitle ?? AppColors.BLACK_500,
                      ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
            SizedBox(
              height: SpaceBox.sizeBig,
            ),
            Container(
              width: double.infinity,
              height: 0.5,
              decoration: const BoxDecoration(
                color: AppColors.BLACK_200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
