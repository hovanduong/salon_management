import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import '../../../utils/utils.dart';
import 'app_barge.dart';
import 'notification_firebase.dart';

//This method will be call in background where have a new message

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  //Do not thing...
  return FirebaseCloudMessaging._handler(message);
}

class FirebaseCloudMessaging {
  static final FirebaseMessaging instance = FirebaseMessaging.instance;

  static dynamic initFirebaseMessaging() async {
    if (Platform.isIOS) {
      await instance.requestPermission();
    }
    FirebaseMessaging.onMessage.listen((message) async {
      log('OnMessage: ${message..data}');
      _handler(message, show: true);
      await AppBarge.addBarge();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('OnMessageOpenedApp: ${message.data}');
      _handler(message, show: true);
    });
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    final initMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initMessage != null) {
      _handler(initMessage);
    }
  }

  static dynamic _handler(RemoteMessage message, {bool show = false}) {
    if (show) {
      LocalNotification.showNotification(
        message.notification?.title,
        message.notification?.body,
        '',
      );
      notificationSubject.add(true);
    } else {
      // selectNotificationSubject.add(payload.toString());
    }
  }
}
