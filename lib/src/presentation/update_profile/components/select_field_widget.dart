import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class BuildSelectFieldWidget extends StatelessWidget {
  const BuildSelectFieldWidget({
    super.key, this.labelText, 
    this.content, 
    this.isDate=false,
    this.validator, this.onTap,
  });
    final String? labelText;
    final String? content;
    final bool isDate;
    final Function()? onTap;
    final String? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Paragraph(
          content: labelText ?? '',
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w600,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: InkWell(
            onTap: () {
              onTap!();
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeToPadding.sizeVerySmall),
                  ),
                  border: Border.all(color: AppColors.BLACK_200),),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  const SizedBox(width: 7),
                  Paragraph(
                    textAlign: TextAlign.start,
                    style: STYLE_MEDIUM.copyWith(color: AppColors.BLACK_400),
                    content: content,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (validator!=null) Paragraph(
          textAlign: TextAlign.center,
          content: validator,
          fontWeight: FontWeight.w500,
          color: AppColors.PRIMARY_RED,
        ) else Container(),
      ],
    );
  }
}
