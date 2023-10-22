import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    this.title,
    this.content,
    this.color,
    this.isSpaceBetween = true,
    this.width, 
    this.dividerTop=false, 
    this.dividerBottom=false,
  });

  final String? title;
  final String? content;
  final Color? color;
  final bool isSpaceBetween;
  final bool dividerTop;
  final bool dividerBottom;
  final double? width;

  Widget buildDivider() {
    return const Divider(
      color: AppColors.BLACK_300,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(isSpaceBetween);
    return Column(
      children: [
        if(dividerTop) buildDivider(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
          child: Row(
            mainAxisAlignment: isSpaceBetween
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Paragraph(
                content: title ?? '',
                style: STYLE_MEDIUM.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: SpaceBox.sizeSmall,
              ),
              SizedBox(
                width: !isSpaceBetween ? MediaQuery.sizeOf(context).width/1.5
                  : null,
                child: Paragraph(
                  content: content ?? '',
                  style: STYLE_MEDIUM.copyWith(
                      color: color, fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if(dividerBottom) buildDivider(),
      ],
    );
  }
}
