import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class MoneyHighlightWidget extends StatelessWidget {
  const MoneyHighlightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        gradient:  const LinearGradient(
          colors: [
            AppColors.PRIMARY_PINK,
            AppColors.SECONDARY_PINK,
          ],
        ),
      ),
      child: Paragraph(
        content: '100,000 VND',
        style: STYLE_MEDIUM_BOLD.copyWith(
          color: AppColors.COLOR_WHITE,
        ),
      ),
    );
  }
}
