import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class NameFieldWidget extends StatelessWidget {
  const NameFieldWidget(
    {super.key,
    this.name,
    this.nameController,
    this.hintText,
    this.textAlign, 
    this.onTap,
    this.isOnTap=false, 
    this.onAddPhone, 
    this.isAddCustomer=false,
  });
  final TextEditingController? nameController;
  final String? name;
  final String? hintText;
  final TextAlign? textAlign;
  final Function()? onTap;
  final Function()? onAddPhone;
  final bool isOnTap;
  final bool isAddCustomer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SpaceBox.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Paragraph(
                    content: name,
                    fontWeight: FontWeight.w600,
                  ),
                  const Paragraph(
                    content: '*',
                    fontWeight: FontWeight.w600,
                    color: AppColors.PRIMARY_RED,
                  ),
                ],
              ),
              if (isAddCustomer) IconButton(
                icon: const Icon(Icons.add_circle),
                color: AppColors.PRIMARY_GREEN,
                onPressed: () {
                  onAddPhone!();
                },
              ) else Container(),
            ],
          ),
          SizedBox(
            height: SpaceBox.sizeVerySmall,
          ),
          InkWell(
            onTap: () {
              if(isOnTap){
                onTap!();
              }
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
                border: Border.all(
                  color: AppColors.BLACK_200,
                ),
              ),
              child: TextFormField(
                textAlign: textAlign ?? TextAlign.start,
                enabled: false,
                controller: nameController,
                style: const TextStyle(color: AppColors.BLACK_500),
                decoration: InputDecoration(
                  hintText: hintText,
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
