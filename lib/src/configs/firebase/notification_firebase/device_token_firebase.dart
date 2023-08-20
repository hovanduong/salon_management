import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class DeviceToken {
  static Future<void> setToken() async {
    // final deviceToken = await AppPref.getDeviceToken();
    // debugPrint('deviceToken: $deviceToken');
    // if (deviceToken == '' || deviceToken == null || deviceToken.isEmpty) {
    //   final getDeviceToken = await FirebaseMessaging.instance.getToken();
    //   await AppPref.setDeviceToken(getDeviceToken!);
    //   debugPrint('deviceToken: $getDeviceToken');
    // }
  }
}
