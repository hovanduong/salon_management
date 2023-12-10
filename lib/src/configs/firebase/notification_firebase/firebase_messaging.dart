import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import '../../../utils/utils.dart';
import 'notification_firebase.dart';

//This method will be call in background where have a new message

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  //Do not thing...
  return FirebaseCloudMessaging._handler(message);
}

class AppBarge {
  static void addBadge() async {
    final userId = await AppPref.getDataUSer('id');
    print(userId);
    final documentReference =
        FirebaseFirestore.instance.collection('Notification').doc(userId);
    try {
      final snapshot = await documentReference.get();

      if (snapshot.exists) {
        // Dữ liệu có sẵn trong snapshot.data
        final userData = snapshot.data()!;
        print('User data: $userData');
        final count = userData['count'];
        await FlutterAppBadger.updateBadgeCount(count);
        if (count == 0) {
          AppBarge.removeBadge();
        }
      } else {
        AppBarge.removeBadge();
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  static void removeBadge() {
    FlutterAppBadger.removeBadge();
  }
}

class FirebaseCloudMessaging {
  static final FirebaseMessaging instance = FirebaseMessaging.instance;

  static dynamic initFirebaseMessaging() async {
    if (Platform.isIOS) {
      await instance.requestPermission();
    }
    FirebaseMessaging.onMessage.listen((message) {
      log('OnMessage: ${message..data}');
      _handler(message, show: true);
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
