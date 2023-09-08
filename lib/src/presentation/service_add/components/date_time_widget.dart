import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    super.key,
    this.onPressedDay,
    this.day,
    this.onPressedTime,
    this.time,
  });
  final Future<void>? onPressedDay;
  final Future<void>? onPressedTime;
  final String? day;
  final String? time;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Paragraph(
              content: 'Choose date',
              fontWeight: FontWeight.w600,
            ),
            Paragraph(
              content: 'Choose time',
              fontWeight: FontWeight.w600,
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () async {
                    await onPressedDay;
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.FIELD_GREEN),
                  ),
                  child: Paragraph(
                    content: day,
                  )),
            ),
            SizedBox(
              width: SpaceBox.sizeMedium,
            ),
            Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      await onPressedTime;
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.FIELD_GREEN),
                    ),
                    child: Paragraph(
                      content: time,
                    )))
          ],
        ),
      ],
    );
  }
}
