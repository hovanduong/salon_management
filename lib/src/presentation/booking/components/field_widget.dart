import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class FieldWidget extends StatelessWidget {
  const FieldWidget({super.key, 
    this.content, this.isBorder=false, 
    this.labelText, this.onTap, this.isonTap=false, 
    this.validator,
  });
  final String? labelText;
  final String? content;
  final bool isBorder;
  final Function? onTap;
  final bool isonTap;
  final String? validator;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Paragraph(
          content: labelText??'',
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          height: SpaceBox.sizeVerySmall,
        ),
        InkWell(
          onTap: () {
            if(isonTap==true){
              onTap!();
            }
          },
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              vertical: SizeToPadding.sizeSmall,
              horizontal: SizeToPadding.sizeVerySmall,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
              border: Border.all(
                color:isBorder? AppColors.PRIMARY_PINK
                : AppColors.BLACK_200,
              ),
            ),
            child: Paragraph(content: content??'',
              style: STYLE_MEDIUM.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(
          height: SpaceBox.sizeVerySmall,
        ),
        Center(
          child: Paragraph(
            textAlign: TextAlign.center,
            content: validator ?? '',
            fontWeight: FontWeight.w500,
            color: AppColors.PRIMARY_RED,
          ),
        ),
        SizedBox(
          height: SpaceBox.sizeVerySmall,
        ),
      ],
    );
  }
}