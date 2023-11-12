import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ButtonDateTimeWidget extends StatelessWidget {
  const ButtonDateTimeWidget({
    super.key, 
    this.dateTime, 
    this.onShowSelectTime, 
    this.onShowSelectDate,
  });

  final DateTime? dateTime;
  final Function()? onShowSelectTime;
  final Function()? onShowSelectDate;

  @override
  Widget build(BuildContext context) {
    final hours = 
      dateTime!=null? dateTime!.hour.toString().padLeft(2, '0') : null;
    final minutes =
      dateTime!=null? dateTime!.minute.toString().padLeft(2, '0'): null;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Paragraph(
              content: BookingLanguage.chooseTime,
              fontWeight: FontWeight.w600,
            ),
            Paragraph(
              content: BookingLanguage.chooseDay,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => onShowSelectTime!(),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.FIELD_GREEN),
                ),
                child: Paragraph(content: dateTime!=null
                  ? '$hours:$minutes': '',),
              ),
            ),
            SizedBox(
              width: SpaceBox.sizeMedium,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => onShowSelectDate!(),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.FIELD_GREEN),
                ),
                child: Paragraph(
                  content:
                    DateFormat('dd/MM/yyyy').format(dateTime??DateTime.now()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}