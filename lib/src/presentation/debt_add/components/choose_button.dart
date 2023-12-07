import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ChooseButtonWidget extends StatelessWidget {
  const ChooseButtonWidget({super.key, 
    this.isButton=false, 
    this.nameButtonLeft, 
    this.nameButtonRight, 
    this.onTapLeft,
    this.onTapRight, 
    this.titleSelection,
  });

  final bool isButton;
  final String? nameButtonLeft;
  final String? nameButtonRight;
  final String? titleSelection;
  final Function(String? name)? onTapLeft;
  final Function(String? name)? onTapRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitleChoosePerson(),
        Padding(
          padding: EdgeInsets.only(bottom: SizeToPadding.sizeMedium),
          child: Row(
            children: [
              buildButtonSelect(
                nameButtonLeft, 
                isButton: isButton,
              ),
              buildButtonSelect(
                nameButtonRight, 
                isButton: !isButton,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTitleChoosePerson(){
    return Padding(
      padding:  EdgeInsets.only(bottom: SizeToPadding.sizeVerySmall),
      child: Paragraph(
        content: titleSelection??'',
        style: STYLE_SMALL.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildButtonSelect(String? name, {bool isButton=false}) {
    return isButton
    ? Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: AppButton(
            enableButton: true,
            content: name??'',
            onTap: ()=> onTapLeft!(name),
          ),
        ),
      )
    : Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: AppOutlineButton(
            content: name ?? '',
            onTap: () => onTapRight!(name),
          ),
        ),
      );
  }
}
