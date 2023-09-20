import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class NameFieldWidget extends StatelessWidget {
  const NameFieldWidget({
    super.key,
    this.name,
    this.nameController,
  });
  final TextEditingController? nameController;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SpaceBox.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Paragraph(
            content: name,
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
                color: AppColors.BLACK_200,
              ),
            ),
            child: TextField(
              enabled: false,
              controller: nameController,
              style: const TextStyle(color: AppColors.BLACK_500),
              decoration: InputDecoration(
                hintText: BookingLanguage.nameCustomer,
                hintStyle: STYLE_MEDIUM.copyWith(color: AppColors.BLACK_400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: SizeToPadding.sizeSmall,
                  horizontal: SizeToPadding.sizeMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
