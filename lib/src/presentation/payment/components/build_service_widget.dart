import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class BuildServiceWidget extends StatelessWidget {
  const BuildServiceWidget({
    super.key,
    this.onTap,
    this.fields,
  });
  final Function()? onTap;
  final List<Widget>? fields;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Paragraph(
              content: 'Chọn dịch vụ',
              fontWeight: FontWeight.w600,
            ),
            GestureDetector(
              onTap: onTap,
              child: const Icon(
                Icons.add_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
        Column(
          children: fields ?? [],
        ),
      ],
    );
  }
}
