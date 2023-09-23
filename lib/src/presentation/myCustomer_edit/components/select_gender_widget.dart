import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/my_customer_edit_language.dart';

class SelectGenderWidget extends StatefulWidget {
  const SelectGenderWidget({
    super.key, 
    this.onChanged,
  });

  final Function(String value)? onChanged;

  @override
  State<SelectGenderWidget> createState() => _SelectGenderWidgetState();
}

List<String> listStatus=[
  MyCustomerEditLanguage.male ,
  MyCustomerEditLanguage.female, 
  MyCustomerEditLanguage.other,];

class _SelectGenderWidgetState extends State<SelectGenderWidget> {

  String dropValue= listStatus.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SpaceBox.sizeLarge*2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpaceBox.sizeVerySmall),
        color: AppColors.PRIMARY_GREEN,
      ),
      child: DropdownButton(
        padding: EdgeInsets.all(SpaceBox.sizeSmall),
        value: dropValue,
        dropdownColor: AppColors.PRIMARY_GREEN,
        iconEnabledColor: AppColors.COLOR_WHITE,
        underline: Container(),
        items: listStatus.map((value){
          return DropdownMenuItem(
            value: value,
            child: Paragraph(content: value, 
              style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.COLOR_WHITE),
            ),
          );
        }).toList(), 
        onChanged: (value) {
          dropValue=value!;
          widget.onChanged!(value);
          setState(() {});
        },
      ),
    );
  }
}
