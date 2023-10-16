import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class DropdownButtonWidget extends StatelessWidget {
  const DropdownButtonWidget({
    super.key, 
    this.gender, 
    this.genderList, 
    this.onChanged,
  });

  final String? gender;
  final List? genderList;
  final Function(String value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SpaceBox.sizeLarge*2.5,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpaceBox.sizeVerySmall),
        border: Border.all(color: AppColors.BLACK_200, width: 2,)
      ),
      child: DropdownButton(
        padding: EdgeInsets.all(SpaceBox.sizeSmall),
        value: gender,
        isExpanded: true,
        focusColor: AppColors.PRIMARY_GREEN,
        iconEnabledColor: AppColors.PRIMARY_GREEN,
        underline: Container(),
        items: genderList?.map((value){
          return DropdownMenuItem(
            value: value,
            child: Paragraph(content: value, 
              style: STYLE_MEDIUM_BOLD,
            ),
          );
        }).toList(), 
        onChanged: (value) {
          onChanged!(value.toString());
        },
      ),
    );
  }
}
