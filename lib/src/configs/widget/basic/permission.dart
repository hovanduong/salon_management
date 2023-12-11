import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../configs.dart';


class AppPermNotification {
   Future<void> checkPermission(Permission permission, BuildContext context) 
  async{
    final status= await permission.request();
    if(!status.isGranted){
      if(status.isPermanentlyDenied) {
        WarningDialog(
          
        );
        await openAppSettings();
      }
    }
  }
}
