import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../resource/service/auth.dart';
import '../../../resource/service/version_app_api.dart';
import '../../../utils/utils.dart';
import '../../app_result/app_result.dart';

class RegisterTopic {
  static Future<void> updateNewVersion({bool? value}) async {
    await AuthApi().newVersionApp(value: value ?? false);
  }

  static Future<bool?> checkRegisTopic() async {
    final resultCheck = await VersionAppApi().checkAppVersion();
    final resultMaxVersion = await VersionAppApi().getMaxVerSion();
    final value = switch (resultCheck) {
      Success(value: final currentVersion) => currentVersion,
      Failure(exception: final exception) => exception,
    };
    final valueMaxVersion = switch (resultMaxVersion) {
      Success(value: final currentVersion) => currentVersion,
      Failure(exception: final exception) => exception,
    };

    if (value is Exception || valueMaxVersion is Exception) {
      throw 'error';
    }

    if (value is int && valueMaxVersion is int && value == valueMaxVersion) {
      return true;
    }
    return false;
  }

  static Future<void> unsubscribeApp() async {
    final result = await checkRegisTopic();
    if (result!) {
      await FirebaseMessaging.instance.subscribeToTopic('AppUpdateReminder');
      await updateNewVersion(value: true);
    } else {
      await FirebaseMessaging.instance
          .unsubscribeFromTopic('AppUpdateReminder');
      await updateNewVersion(value: false);
    }
  }

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
        await unsubscribeApp();
      }
    } else {
      // For non-iOS platforms, subscribe to topics directly
      await FirebaseMessaging.instance.subscribeToTopic(userId ?? '');
      await unsubscribeApp();
    }
  }
}
