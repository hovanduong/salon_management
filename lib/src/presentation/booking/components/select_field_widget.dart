import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class SelectFieldWidget extends StatelessWidget {
  const SelectFieldWidget({super.key, 
    this.labelText, 
    this.list, 
    this.content, 
    this.isDate=false, 
    this.type, this.onTap,
  });
  
  final String? labelText;
  final List<String>? list;
  final  String? content;
  final  bool isDate ;
  final  String? type;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Paragraph(
          content: labelText ?? '',
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w600,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: InkWell(
            onTap: () {
              onTap!();
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeToPadding.sizeVerySmall),
                ),
                border: Border.all(color: AppColors.BLACK_200),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  const SizedBox(width: 7),
                  Paragraph(
                    textAlign: TextAlign.start,
                    style: STYLE_MEDIUM.copyWith(color: AppColors.BLACK_400),
                    content: content,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}