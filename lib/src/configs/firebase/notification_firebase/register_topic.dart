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
    // final resultMaxVersion = await VersionAppApi().getMaxVerSion();
    // final valueMaxVersion = switch (resultMaxVersion) {
    // Success(value: final currentVersion) => currentVersion,
    // Failure(exception: final exception) => exception,
    final resultCheck = await VersionAppApi().checkAppVersion();
    const currentVersion = 2;

    final value = switch (resultCheck) {
      Success(value: final currentVersion) => currentVersion,
      Failure(exception: final exception) => exception,
    };

    if (value is int && currentVersion == value) {
      // await VersionAppApi().postVersionApp(currentVersion);
      return true;
    }
    return false;
  }

  static Future<void> unsubscribeApp() async {
    final result = await checkRegisTopic();
    if (result!) {
      await FirebaseMessaging.instance
          .unsubscribeFromTopic('AppUpdateReminder');
      await updateNewVersion(value: false);
    } else {
      await FirebaseMessaging.instance.subscribeToTopic('AppUpdateReminder');
      await updateNewVersion(value: true);
    }
  }

  static Future<void> registerTopic() async {
    final userId = await AppPref.getDataUSer('id');
    print(userId);
    // Request notification permission
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings =
        await messaging.requestPermission(provisional: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    if (Platform.isIOS) {
      var apnsToken;
      try {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      } catch (e) {
        print('Error getting APNs Token: $e');
      }

      if (apnsToken == null) {
        await Future<void>.delayed(const Duration(seconds: 3));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      }

      if (apnsToken != null) {
        await FirebaseMessaging.instance.subscribeToTopic(userId ?? '');
        await unsubscribeApp();
      }
    } else {
      print(await FirebaseMessaging.instance.getToken());
      await FirebaseMessaging.instance.subscribeToTopic(userId ?? '');
      await unsubscribeApp();
    }
  }
}
