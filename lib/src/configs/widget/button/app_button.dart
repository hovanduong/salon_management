// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';

import '../../configs.dart';
import '../../constants/app_space.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.enableButton = false,
    this.content,
    this.onTap, this.width, 
  }) : super(key: key);
  final Function? onTap;
  final bool enableButton;
  final String? content;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => enableButton ? onTap!() : null,
      child: Container(
        width: width?? MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              if (enableButton) AppColors.LINEAR_GREEN else AppColors.BLACK_200,
              if (enableButton)
                AppColors.SECONDARY_PINK
              else
                AppColors.BLACK_200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(BorderRadiusSize.sizeSmall),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(5, 5),
              blurRadius: 10,
            )
          ],
        ),
        child: Paragraph(
          content: content,
          textAlign: TextAlign.center,
          style: STYLE_MEDIUM.copyWith(
            color: enableButton ? AppColors.COLOR_WHITE : AppColors.BLACK_300,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
