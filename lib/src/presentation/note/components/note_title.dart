import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../resource/model/model.dart';
import '../../../utils/date_format_utils.dart';

class NoteTitleWidget extends StatelessWidget {
  const NoteTitleWidget({super.key, 
    this.note,  
    this.index,
    this.color,
    this.onTap,
  });

  final NoteModel? note;
  final int? color;
  final int? index;
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
          color: color!=null? AppColors.BLACK_500
           :AppColors.BLACK_500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Paragraph(
              content: note?.title??'',
              maxLines: 1,
              style: STYLE_MEDIUM.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.COLOR_WHITE,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: SizeToPadding.sizeVerySmall,),
            Paragraph(
              content: note?.note??'',
              maxLines: 4,
              style: STYLE_SMALL.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.COLOR_WHITE,
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
                  style:STYLE_SMALL.copyWith(color: AppColors.COLOR_WHITE)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
