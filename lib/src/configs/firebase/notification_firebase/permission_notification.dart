import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../configs.dart';

class AppPermNotification {
  static Future<bool> checkPermission(
    Permission permission,
    BuildContext context,
  ) async {
    final status = await permission.status;
    if (Platform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings =
          await messaging.requestPermission(provisional: true);
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        return true;
      } else {
        return false;
      }
    }
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // Quyền đã từ chối nhưng không phải là "Không hiển thị lại"
      final newStatus = await permission.request();
      if (newStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      // Quyền bị "Không hiển thị lại"
      // showPermissionRationale(context);
      return false;
    } else {
      // Trạng thái khác
      return false;
    }
  }

  static dynamic showDialogSettings(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          content: BookingLanguage.contentSetting,
          image: AppImages.icPlus,
          title: SignUpLanguage.notification,
          leftButtonName: SignUpLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: BookingLanguage.settings,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async {
            Navigator.pop(context);
            await openAppSettings();
          },
        );
      },
    );
  }
}
