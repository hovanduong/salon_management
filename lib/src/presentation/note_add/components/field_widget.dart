import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class FieldWidget extends StatelessWidget {
  const FieldWidget({super.key, 
    this.onChange, 
    this.textEditingController, 
    this.fontSize, 
    this.hintText, 
    this.validator, 
    this.color,
  });

  final Function(String value)? onChange;
  final TextEditingController? textEditingController;
  final double? fontSize;
  final String? hintText;
  final String? validator;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        TextFormField(
          onChanged: (value) => onChange!(value),
          controller: textEditingController,
          style: TextStyle(fontSize: fontSize, color: AppColors.BLACK_500),
          cursorColor: color==AppColors.COLOR_WHITE? AppColors.BLACK_500:
            AppColors.COLOR_WHITE,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(
            hintText: hintText??'',
            hintStyle: STYLE_MEDIUM.copyWith(fontSize: fontSize,
              color: AppColors.BLACK_400,),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color?? AppColors.COLOR_WHITE),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide.none),
          ),
        ),
        SizedBox(
          height: SpaceBox.sizeVerySmall,
        ),
        Paragraph(
          textAlign: TextAlign.center,
          content: validator ?? '',
          fontWeight: FontWeight.w500,
          color: AppColors.PRIMARY_RED,
        ),
      ] 
    );
  }
}
