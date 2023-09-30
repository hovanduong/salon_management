import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../configs/configs.dart';

class ItemHistoryListWidget extends StatelessWidget {
  const ItemHistoryListWidget(
      {super.key,
      this.image,
      this.title,
      this.date,
      this.money,
      this.colorMoney,});
  final String? image;
  final String? title;
  final String? date;
  final String? money;
  final Color? colorMoney;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (image != null) SvgPicture.asset(image!),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Paragraph(
                    content: title ?? '',
                    style: STYLE_LARGE_BOLD.copyWith(
                      color: AppColors.BLACK_500,
                    ),
                  ),
                  Paragraph(
                    content: date ?? '',
                    style: STYLE_MEDIUM.copyWith(
                      color: AppColors.COLOR_GREY,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Paragraph(
            content: money ?? '',
            style: STYLE_LARGE_BOLD.copyWith(
              color: colorMoney ?? AppColors.PRIMARY_GREEN,
            ),
          ),
        ],
      ),
    );
  }
}
