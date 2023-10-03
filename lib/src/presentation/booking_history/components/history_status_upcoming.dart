import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import 'components.dart';

class StatusUpWidget{
  static Widget statusUpComing(String status){
    switch (status) {
      case 'confirmed':
        return StatusService(
          content: HistoryLanguage.confirmed,
          color: AppColors.PRIMARY_PINK,
        );
      case 'done':
        return StatusService(
          content: HistoryLanguage.done,
          color: AppColors.PRIMARY_GREEN,
        );
      default:
        return StatusService(
          content: HistoryLanguage.canceled,
          color: AppColors.PRIMARY_RED,
        );
    }
  }
}
