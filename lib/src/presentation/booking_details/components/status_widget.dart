import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import 'components.dart';

class StatusWidget{
  static Widget status(String status){
    switch (status) {
      case 'Confirmed':
        return StatusService(
          content: HistoryLanguage.confirmed,
          color: AppColors.PRIMARY_PINK,
        );
      case 'Canceled':
        return StatusService(
          content: HistoryLanguage.canceled,
          color: AppColors.PRIMARY_RED,
        );
      default:
        return StatusService(
          content: HistoryLanguage.done,
          color: AppColors.COLOR_GREEN_LIST,
        );
    }
  }
}
