import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class DropButtonWidget extends StatelessWidget {
  const DropButtonWidget({super.key, 
    this.list, 
    this.onChanged, this.dropValue, 
    this.labelText, this.validator,
  });

  final List<String>? list;
  final Function(Object)? onChanged;
  final Object? dropValue;
  final String? labelText;
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
        DropdownButtonFormField(
          items: list?.map((value) => DropdownMenuItem(
            value: value,
            child: Paragraph(content: value,
              style: STYLE_MEDIUM.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),).toList(), 
          onChanged: (value){
            onChanged!(value!);
          },
          borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: SizeToPadding.sizeSmall,
              horizontal: SizeToPadding.sizeVerySmall,
            ),
            hintStyle: STYLE_MEDIUM.copyWith(color: AppColors.BLACK_400),
            fillColor: AppColors.COLOR_WHITE,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
              borderSide: BorderSide(
                color: validator==''? AppColors.BLACK_200 : AppColors.PRIMARY_PINK,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
              borderSide: const BorderSide(
                color: AppColors.BLACK_200,
              ),
            ),
          ),
          value: dropValue,
          style:const TextStyle(color: AppColors.BLACK_500),
          icon:const Icon(Icons.arrow_drop_down),
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