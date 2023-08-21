import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class TransactionsTextWidget extends StatelessWidget {
  const TransactionsTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Paragraph(
          content: 'Transactions',
          style: STYLE_LARGE_BIG,
        ),
      ),
    );
  }
}
