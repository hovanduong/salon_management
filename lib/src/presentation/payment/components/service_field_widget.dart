import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ServiceFieldWidget extends StatelessWidget {
  const ServiceFieldWidget({
    super.key,
    this.nameService,
    this.onRemove,
  });
  final String? nameService;
  final VoidCallback? onRemove;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SpaceBox.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.remove,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
              border: Border.all(
                color: AppColors.FIELD_GREEN,
              ),
            ),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: nameService,
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
