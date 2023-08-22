import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.arrow_back_ios_new),
          const Paragraph(
            content: 'Statistics',
            style: STYLE_MEDIUM_BOLD,
          ),
          Image.asset(AppImages.imagedowload), // chữ D viết hoa
        ],
      ),
    );
  }
}
