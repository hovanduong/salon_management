import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class FloatingButtonWidget extends StatelessWidget {
  const FloatingButtonWidget({
    super.key, this.onPressed, 
    this.content='', this.iconData, 
    this.heroTag,
  });

  final Function()? onPressed;
  final String content;
  final String? heroTag;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeVerySmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (content != '') GestureDetector(
            onTap: () => onPressed!(),
            child: Container(
              padding: EdgeInsets.all(Size.sizeSmall),
              decoration: BoxDecoration(
                color: AppColors.SECONDARY_GREEN,
                borderRadius: BorderRadius.circular(SpaceBox.sizeSmall),
              ),
              child: Paragraph(
                content: content,
                style: STYLE_SMALL_BOLD.copyWith(
                  color: AppColors.COLOR_WHITE,
                ),
              ),
            ),
          ) else Container(),
          SizedBox(width: SpaceBox.sizeSmall,),
          FloatingActionButton(
            heroTag: heroTag,
            backgroundColor: AppColors.PRIMARY_GREEN,
            onPressed: (){
              onPressed!();
            },
            child: Icon(iconData, color: AppColors.COLOR_WHITE,),
          ),
        ],
      ),
    );
  }
}
