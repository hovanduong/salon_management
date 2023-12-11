import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../configs/configs.dart';


class AppPermNotification {
  static Future<bool> checkPermission(
    Permission permission, BuildContext context) 
  async{
    final status= await permission.request();
    if(!status.isGranted){
      return false;
    }else{
      return true;
    }
  }

  static dynamic showDialogSettings(BuildContext context)async{
     await showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          content: BookingLanguage.contentSetting,
          image: AppImages.icBellApp,
          title: SignUpLanguage.notification,
          leftButtonName: SignUpLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: BookingLanguage.settings,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async{
            await openAppSettings();
          },
        );
      },
     );
  }
}
