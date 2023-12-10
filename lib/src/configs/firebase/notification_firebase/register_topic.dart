import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../utils/utils.dart';

class RegisterTopic {
  static Future<void> registerTopic() async {
    final userId = await AppPref.getDataUSer('id');
    final notificationSettings =
        await FirebaseMessaging.instance.requestPermission(provisional: true);

    if (Platform.isIOS) {
      var apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        await FirebaseMessaging.instance.subscribeToTopic(userId ?? '');
        await FirebaseMessaging.instance.subscribeToTopic('AppUpdateReminder');
      } else {
        await Future<void>.delayed(
          const Duration(
            seconds: 3,
          ),
        );
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          await FirebaseMessaging.instance.subscribeToTopic(userId ?? '');
          await FirebaseMessaging.instance
              .subscribeToTopic('AppUpdateReminder');
        }
      }
    } else {
      await FirebaseMessaging.instance.subscribeToTopic(userId ?? '');
      await FirebaseMessaging.instance.subscribeToTopic('AppUpdateReminder');
    }
  }
}
