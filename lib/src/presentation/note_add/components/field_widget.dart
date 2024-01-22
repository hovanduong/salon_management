import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class FieldWidget extends StatelessWidget {
  const FieldWidget({super.key, 
    this.textEditingController, 
    this.fontSize, 
    this.hintText,  
    this.color,
  });
  final TextEditingController? textEditingController;
  final double? fontSize;
  final String? hintText;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        TextFormField(
          controller: textEditingController,
          style: TextStyle(fontSize: fontSize,),
          cursorColor:  AppColors.BLACK_500,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(
            hintText: hintText??'',
            
            hintStyle: STYLE_MEDIUM.copyWith(fontSize: fontSize,
              color: color!=const Color(0xff2f4f4f)?
              AppColors.BLACK_500: AppColors.COLOR_WHITE),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color?? AppColors.COLOR_WHITE),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide.none),
          ),
        ),
      ] 
    );
  }
}