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
    this.colorImage, this.onTap, 
    this.isOntap= false,
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
        onTap: (){
          if(isOntap==true){
            onTap!();
          }
        },
        child: Row(
          children: [
            if (image != null) SvgPicture.asset(image!, color: colorImage),
            SizedBox(
              width: SpaceBox.sizeBig,
            ),
            Paragraph(
              content: title ?? '',
              style: textStyleTitle ??
                  STYLE_MEDIUM_BOLD.copyWith(
                    color: colorTitle ?? AppColors.BLACK_500,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
