import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class SelectStatusWidget extends StatefulWidget {
  const SelectStatusWidget({
    super.key, 
    this.status, 
    this.onChanged,
  });

  final String? status;
  final Function(String value)? onChanged;

  @override
  State<SelectStatusWidget> createState() => _SelectStatusWidgetState();
}

List<String> listStatus=[HistoryLanguage.confirmed, HistoryLanguage.cancel,];

class _SelectStatusWidgetState extends State<SelectStatusWidget> {

  String dropValue= listStatus.first;

  @override
  Widget build(BuildContext context) {
    for(var i=0; i<listStatus.length; i++){
      if(listStatus[i].contains(widget.status!)){
        dropValue=listStatus[i];
      }
    }
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
          widget.onChanged!(value!);
        },
      ),
    );
  }
}
