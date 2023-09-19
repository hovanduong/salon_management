import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import 'components/components.dart';

class StatusCanceledWidget{
  static Widget statusCanceled(){
    return StatusService(
      content: HistoryLanguage.canceled,
      color: AppColors.PRIMARY_RED,
    );
  }
}