import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class SelectStatusWidget extends StatefulWidget {
  const SelectStatusWidget({
    super.key,
    this.status,
    this.onChanged, 
    this.color,
    this.money,
  });

  final String? status;
  final Function(String value)? onChanged;
  final Color? color;
  final num? money;

  @override
  State<SelectStatusWidget> createState() => _SelectStatusWidgetState();
}

List<String> listStatus = [
  HistoryLanguage.confirmed,
  HistoryLanguage.cancel,
];

class _SelectStatusWidgetState extends State<SelectStatusWidget> {
  String dropValue = listStatus.first;
  

  @override
  Widget build(BuildContext context) {
    listStatus.remove(HistoryLanguage.done);
    for (var i = 0; i < listStatus.length; i++) {
      if (listStatus[i].contains(widget.status!)) {
        dropValue = listStatus[i];
      }
    }
    if(widget.money==null){
      listStatus.add(HistoryLanguage.done);
    }else{
      listStatus.remove(HistoryLanguage.done);
    }
    return Container(
      height: SpaceBox.sizeLarge * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpaceBox.sizeVerySmall),
        color: widget.color?? AppColors.PRIMARY_GREEN,
      ),
      child: DropdownButton(
        padding: EdgeInsets.all(SpaceBox.sizeSmall),
        value: dropValue,
        dropdownColor: widget.color?? AppColors.PRIMARY_GREEN,
        iconEnabledColor: AppColors.COLOR_WHITE,
        underline: Container(),
        items: listStatus.map((value) {
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
        }).toList(),
        onChanged: (value) {
          widget.onChanged!(value!);
        },
      ),
    );
  }
}
