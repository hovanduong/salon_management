import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import 'device_token_firebase.dart';
import 'firebase_messaging.dart';
import 'local_notification.dart';
import 'notification_data.dart';

export 'firebase_messaging.dart';
export 'local_notification.dart';
export 'notification_data.dart';

void notificationInitialed() {
  FirebaseCloudMessaging.initFirebaseMessaging();
  LocalNotification.setup();
  DeviceToken.setToken();
}

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();
final BehaviorSubject<bool> notificationSubject = BehaviorSubject<bool>();

StreamSubscription? _subscription;

dynamic configureSelectNotificationSubject(Function(Data payload) redirect) {
  _subscription =
      selectNotificationSubject.stream.listen((String? _payload) async {
    if (_payload == null) {
      return;
    }
    try {
      final payload = Data.fromJson(jsonDecode(_payload));
      redirect(payload);
    } catch (e) {
      print('Error redirect by notification: $e');
    } finally {
      selectNotificationSubject.add(null);
    }
  });
}

void unConfigureSelectNotificationSubject() {
  _subscription?.cancel();
  _subscription = null;
}
