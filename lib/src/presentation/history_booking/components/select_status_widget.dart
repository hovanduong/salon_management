import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class SelectStatusWidget extends StatefulWidget {
  const SelectStatusWidget({
    super.key, 
    this.status
  });

  final String? status;

  @override
  State<SelectStatusWidget> createState() => _SelectStatusWidgetState();
}

List<String> listStatus=['Mới' ,HistoryLanguage.confirmed, HistoryLanguage.cancel,];

class _SelectStatusWidgetState extends State<SelectStatusWidget> {

  String dropValue= listStatus.first;
  
  @override
  Widget build(BuildContext context) {
    if(widget.status!=null){
      listStatus.forEach((element) {
        if(element.contains(widget.status!)){
          dropValue=element;
        }
      });
    }
    // dropValue=listStatus[2];
    return Container(
      height: SpaceBox.sizeLarge*2,
      padding: EdgeInsets.all(SpaceBox.sizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpaceBox.sizeVerySmall),
        color: AppColors.PRIMARY_GREEN,
      ),
      child: DropdownButton(
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
          if(value!=listStatus.first){
            setState(() {
              dropValue=value!;
            }); 
          }
        },
      ),
    );
  }
}
