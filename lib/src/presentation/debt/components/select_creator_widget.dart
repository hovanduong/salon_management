// ignore_for_file: prefer_null_aware_operators

import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class SelectCreatorWidget extends StatelessWidget {
  const SelectCreatorWidget({
    super.key,
    this.onChanged, 
    this.color,
    this.listName, 
    this.dropValue,
  });

  final Function(String value)? onChanged;
  final Color? color;
  final List<String>? listName;
  final String? dropValue;

  @override
  Widget build(BuildContext context) {
    // if(listName!=null){
    //   for (var i = 0; i < (listName?.length??0); i++) {
    //     if (listName![i].contains(name!)) {
    //       dropValue = listName[i];
    //     }
    //   }
    // }
    
    return Container(
      height: SpaceBox.sizeLarge * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpaceBox.sizeVerySmall),
        color: color?? AppColors.PRIMARY_GREEN,
      ),
      child: DropdownButton(
        padding: EdgeInsets.all(SpaceBox.sizeSmall),
        value: dropValue,
        dropdownColor: color?? AppColors.PRIMARY_GREEN,
        iconEnabledColor: AppColors.COLOR_WHITE,
        underline: Container(),
        items: listName!=null? listName?.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Paragraph(
              content: value,
              style: STYLE_MEDIUM.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(): null,
        onChanged: (value) {
          onChanged!(value!);
        },
      ),
    );
  }
}
