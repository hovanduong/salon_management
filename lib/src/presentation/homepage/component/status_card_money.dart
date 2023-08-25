import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class StatusCardMoney extends StatelessWidget {
  const StatusCardMoney({super.key, 
    this.content, this.icon, this.money, 
    this.crossAxisAlignment= CrossAxisAlignment.start});

  final String? content;
  final IconData? icon;
  final String? money;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.15),
                borderRadius: BorderRadius.all(
                  Radius.circular(999),
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.COLOR_WHITE,
                size: 20,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Paragraph(
              content: content ?? '',
              style: STYLE_MEDIUM.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: SpaceBox.sizeSmall,),
        Paragraph(
          content: money ?? '',
          style: STYLE_LARGE_BIG.copyWith(
            color: AppColors.COLOR_WHITE,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}