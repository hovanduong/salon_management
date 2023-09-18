import 'package:flutter/material.dart';

import '../../configs/constants/app_colors.dart';
import 'components/components.dart';

class StatusUpComingWidget{
  static Widget statusUpComing(String status){
    switch (status) {
      case 'confirm':
        return const StatusService(
          content: 'Đã xác nhận',
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