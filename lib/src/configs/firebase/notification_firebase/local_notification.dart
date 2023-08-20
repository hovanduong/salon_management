// ignore_for_file: avoid_types_on_closure_parameters

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_firebase.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails? notificationAppLaunchDetails;

class LocalNotification {
  static const String _id = 'EnglishChallengeID';
  static const String _channel = 'EnglishChallengeChannel';
  static const String _description = 'Description';

  static dynamic setup() async {
    //setup local notification
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    final initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        selectNotificationSubject.add(payload);
        await flutterLocalNotificationsPlugin.cancel(id);
      },
    );
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        selectNotificationSubject.add(payload);
      },
    );
  }

  static Future<void> showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _id,
      _channel,
      channelDescription: _description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      '${title ?? 'Say hi!'} ',
      body ?? 'Nice to meet you again!',
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
