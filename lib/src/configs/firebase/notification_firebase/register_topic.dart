import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../utils/utils.dart';

class RegisterTopic {
  static Future<void> registerTopic() async {
    final userId = await AppPref.getDataUSer('id');

    // Request notification permission
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings =
        await messaging.requestPermission(provisional: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Check if the platform is iOS
    if (Platform.isIOS) {
      // Get APNS token
      var apnsToken;
      try {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        // Handle apnsToken if no error
      } catch (e) {
        print('Error getting APNs Token: $e');
        // Handle error here
      }

      // Retry after a delay if the token is not received immediately
      if (apnsToken == null) {
        await Future<void>.delayed(const Duration(seconds: 3));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      }

      // Subscribe to topics if the APNS token is available
      if (apnsToken != null) {
        await FirebaseMessaging.instance.subscribeToTopic(userId ?? '');
        await FirebaseMessaging.instance.subscribeToTopic('AppUpdateReminder');
      }
      String? apnsToken1 = await messaging.getAPNSToken();
      print(apnsToken1);
    } else {
      // For non-iOS platforms, subscribe to topics directly
      await FirebaseMessaging.instance.subscribeToTopic(userId ?? '');
      await FirebaseMessaging.instance.subscribeToTopic('AppUpdateReminder');
    }
  }
}
