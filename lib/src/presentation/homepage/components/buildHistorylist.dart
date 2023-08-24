import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class HistoryListWidget extends StatelessWidget {
  const HistoryListWidget({
    super.key,
    this.image,
    this.title,
    this.date,
    this.money,
  });
  final DecorationImage? image;
  final String? title;
  final String? date;
  final String? money;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                image: image,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Paragraph(
                  content: title,
                  style: STYLE_LARGE_BOLD.copyWith(
                    color: AppColors.BLACK_500,
                  ),
                ),
                Paragraph(
                  content: title,
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.COLOR_GREY,
                  ),
                ),
              ],
            ),
          ],
        ),
        Paragraph(
          content: title,
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.FIELD_GREEN,
          ),
        ),
      ],
    );
  }
}
