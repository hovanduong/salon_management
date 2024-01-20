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
  });

  final Function(String value)? onChange;
  final TextEditingController? textEditingController;
  final double? fontSize;
  final String? hintText;
  final String? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        TextFormField(
          onChanged: (value) => onChange!(value),
          controller: textEditingController,
          style: TextStyle(fontSize: fontSize, color: AppColors.BLACK_500),
          cursorColor: Colors.white,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(
            hintText: hintText??'',
            hintStyle: STYLE_MEDIUM.copyWith(fontSize: fontSize,
              color: AppColors.BLACK_400,),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.PRIMARY_GREEN),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.COLOR_WHITE),
            ),
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
