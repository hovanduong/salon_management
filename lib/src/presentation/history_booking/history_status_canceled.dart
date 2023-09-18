import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import 'components/components.dart';

class StatusCanceledWidget{
  static Widget statusCanceled(){
    return const StatusService(
      content: 'Đã hủy',
      color: AppColors.PRIMARY_RED,
    );
  }
}