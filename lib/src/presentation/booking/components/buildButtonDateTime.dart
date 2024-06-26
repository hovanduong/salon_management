// ignore_for_file: prefer_null_aware_operators

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ButtonDateTimeWidget extends StatelessWidget {
  const ButtonDateTimeWidget({
    super.key, 
    this.dateTime, 
    this.time, 
    this.onShowSelectTime, 
    this.onShowSelectDate,
  });

  final DateTime? dateTime;
  final DateTime? time;
  final Function()? onShowSelectTime;
  final Function()? onShowSelectDate;

  @override
  Widget build(BuildContext context) {
    final hours = 
      time!=null? time!.hour.toString().padLeft(2, '0') : null;
    final minutes =
      time!=null? time!.minute.toString().padLeft(2, '0'): null;
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
                child: Paragraph(content: time!=null
                  ? '$hours:$minutes': '',
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.COLOR_WHITE,
                  ),
                ),
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
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.COLOR_WHITE,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}