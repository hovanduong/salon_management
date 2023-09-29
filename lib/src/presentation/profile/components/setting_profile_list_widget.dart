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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeVeryBig,
        vertical: SizeToPadding.sizeSmall / 1.1,
      ),
      child: GestureDetector(
        onTap: () {
          onTap!();
        },
        child: Container(
          height: SpaceBox.sizeBig + SpaceBox.sizeBig,
          decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.FIELD_GREEN,
                width: 1,
              ),
              color: const Color.fromARGB(255, 216, 212, 212),
              borderRadius: BorderRadius.circular(BorderRadiusSize.sizeBig)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: SpaceBox.sizeMedium,
              ),
              if (image != null) SvgPicture.asset(image!, color: colorImage),
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
            ],
          ),
        ),
      ),
    );
  }
}
