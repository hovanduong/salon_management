import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ChooseButtonWidget extends StatelessWidget {
  const ChooseButtonWidget({super.key, 
    this.isButton=false, 
    this.isHideButtonMe,
    this.nameButtonLeft, 
    this.nameButtonRight, 
    this.onTapLeft,
    this.onTapRight, 
    this.titleSelection,
  });

  final bool isButton;
  final bool? isHideButtonMe;
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
                isHideButton: isHideButtonMe,
                nameButtonLeft, 
                isButton: isButton,
              ),
              buildButtonSelect(
                isHideButton: isHideButtonMe!=null? !isHideButtonMe! :null,
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

  Widget buildAppButton(String? name, {bool? isHideButton}){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: AppButton(
          enableButton: isHideButton??true,
          content: name??'',
          onTap: ()=> onTapLeft!(name),
        ),
      ),
    );
  }

  Widget buildButtonSelect(String? name, 
    {bool isButton=false, bool? isHideButton,}) {
    return (isHideButton!=null && isHideButton)
    ? buildAppButton(name, isHideButton: !isHideButton) 
    :isButton? buildAppButton(name)
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
