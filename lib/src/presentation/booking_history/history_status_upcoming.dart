import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import 'components/components.dart';

class StatusUpComingWidget{
  static Widget statusUpComing(String status){
    switch (status) {
      case 'confirm':
        return StatusService(
          content: HistoryLanguage.confirmed,
          color: AppColors.PRIMARY_PINK,
        );
      case 'refuse':
        return const StatusService(
          content: 'Từ chối',
          color: AppColors.PRIMARY_RED,
        );
      default:
        return const StatusService(
          content: 'Chờ xác nhận',
          color: AppColors.BLACK_500,
        );
    }
  }
}