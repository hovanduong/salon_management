import 'package:firebase_messaging/firebase_messaging.dart';

class RegisterTopic {
  static Future<void> registerTopic() async {
    // const userId='' // nho bo bat dong // await
    await FirebaseMessaging.instance.subscribeToTopic('13');
    await FirebaseMessaging.instance.subscribeToTopic('AppUpdateReminder');
  }
}
