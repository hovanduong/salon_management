import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../resource/model/model.dart';
import '../../../utils/app_handel_color.dart';
import '../../../utils/date_format_utils.dart';

class NoteTitleWidget extends StatelessWidget {
  const NoteTitleWidget({super.key, 
    this.note,  
    this.color,
    this.onTap,
  });

  final NoteModel? note;
  final int? color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (note?.color!=null && note?.color!='')?
           AppHandleColor.getColorFromHex(note!.color!): null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.BLACK_200)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Paragraph(
              content: note?.title??'',
              maxLines: 1,
              style: STYLE_MEDIUM.copyWith(
                fontWeight: FontWeight.w600,
                color: (note?.color!=null && note?.color!='')?
                  AppHandleColor.getColorFromHex(note!.color!)
                  !=AppColors.COLOR_WHITE?
                  AppColors.COLOR_WHITE: AppColors.BLACK_500: null,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: SizeToPadding.sizeVerySmall,),
            Paragraph(
              content: note?.note??'',
              maxLines: 4,
              style: STYLE_SMALL.copyWith(
                fontWeight: FontWeight.w600,
                color: (note?.color!=null && note?.color!='')?
                  AppHandleColor.getColorFromHex(note!.color!)
                  !=AppColors.COLOR_WHITE?
                  AppColors.COLOR_WHITE: AppColors.BLACK_500: null,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Paragraph(
                  content: note?.updatedAt!= null
                    ? AppDateUtils.splitHourDate(
                        AppDateUtils.formatDateLocal(
                          note!.updatedAt!,
                        ),
                      )
                    : '',
                  style:STYLE_SMALL.copyWith(
                    color: (note?.color!=null && note?.color!='')?
                      AppHandleColor.getColorFromHex(note!.color!)
                      !=AppColors.COLOR_WHITE?
                      AppColors.COLOR_WHITE: AppColors.BLACK_500: null,)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
