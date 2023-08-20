import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key, 
    this.onTap, 
    this.content,
  });
  final Function()? onTap;
  final String? content;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap!(),
      child: Container(
        margin: EdgeInsets.only(
          top: SpaceBox.sizeBig,
          left: SpaceBox.sizeBig*9,
        ),
        width: SpaceBox.sizeBig*9,
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.PRIMARY_PINK,
              AppColors.SECONDARY_PINK
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(BorderRadiusSize.sizeBig),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(5, 5),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Paragraph(
              content: content,
              textAlign: TextAlign.center,
              style: STYLE_MEDIUM.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: SpaceBox.sizeSmall,),
            Icon(
              Icons.arrow_forward_ios_outlined, 
              color: AppColors.COLOR_WHITE,
              size: SpaceBox.sizeMedium,)
          ],
        ),
      ),
    );
  }
}