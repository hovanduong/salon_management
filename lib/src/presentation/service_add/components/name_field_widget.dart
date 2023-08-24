import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class NameFieldWidget extends StatelessWidget {
  const NameFieldWidget({super.key, this.name});
  final String? name;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SpaceBox.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Paragraph(
            content: 'Name',
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: SpaceBox.sizeVerySmall,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
              border: Border.all(
                color: AppColors.FIELD_GREEN,
              ),
            ),
            child: Expanded(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: name,
                  hintStyle: STYLE_MEDIUM.copyWith(color: AppColors.BLACK_400),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: SizeToPadding.sizeSmall,
                    horizontal: SizeToPadding.sizeMedium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
