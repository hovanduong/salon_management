import 'package:flutter/material.dart';

import '../../configs/constants/app_colors.dart';
import 'components/components.dart';

class StatusDoneWidget{
  static Widget statusDone(String status){
    switch (status) {
      case 'checkout':
        return const StatusService(
          content: 'Checkout',
          color: AppColors.PRIMARY_GREEN,
        );
      default:
        return const StatusService(
          content: 'Không đến',
          color: AppColors.YELLOW_STATUS,
        );
    }
  }
}