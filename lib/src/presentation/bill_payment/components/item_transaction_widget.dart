import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ItemTransactionWidget extends StatelessWidget {
  const ItemTransactionWidget({
    super.key, 
    this.title, 
    this.content, 
    this.color, 
    this.isIcon=false,
  });

  final String? title;
  final String? content;
  final Color? color;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryVerySmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(
            content: title ?? '',
            style: STYLE_MEDIUM.copyWith(
              color: AppColors.BLACK_400,
              fontWeight: FontWeight.w600,  
            ),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.topRight,
                width: MediaQuery.of(context).size.width/2.4,
                child: Paragraph(
                  content: content ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: STYLE_MEDIUM.copyWith(
                    color: color?? AppColors.BLACK_500,
                    fontWeight: FontWeight.w600,  
                  ),
                ),
              ),
              if (isIcon) 
                const Icon(Icons.copy, color: AppColors.PRIMARY_GREEN,)
              else Container()
            ],
          ),
        ],
      ),
    );
  }
}
