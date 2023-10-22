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
    this.isTotal=false, 

  });

  final String? title;
  final String? content;
  final Color? color;
  final bool isIcon;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryVerySmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isTotal) Paragraph(
            content: title ?? '',
            style: STYLE_LARGE.copyWith(
              color:  AppColors.PRIMARY_GREEN,
              fontWeight: FontWeight.w700,
            ),
          ) else Paragraph(
            content: title ?? '',
            style: STYLE_MEDIUM.copyWith(
              color:  AppColors.BLACK_400,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.topRight,
                width: MediaQuery.of(context).size.width/1.6,
                child: Paragraph(
                  content: content=='Trống' ? '' : (content??''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: STYLE_MEDIUM.copyWith(
                    color: color?? AppColors.BLACK_500,
                    fontSize: isTotal? 20 : 16,
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
