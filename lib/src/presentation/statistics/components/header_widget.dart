import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class HeaderrWidget extends StatelessWidget {
  const HeaderrWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.arrow_back_ios_new),
          const Paragraph(
            content: 'Statistics',
            style: STYLE_MEDIUM_BOLD,
          ),
          Image.asset(AppImages.imagedowload),
        ],
      ),
    );
  }
}
