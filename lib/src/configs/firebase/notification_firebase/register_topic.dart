import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../utils/utils.dart';

class RegisterTopic {
  static Future<void> registerTopic() async {
    final userId= await AppPref.getDataUSer('id');
    await FirebaseMessaging.instance.subscribeToTopic(userId??'');
    await FirebaseMessaging.instance.subscribeToTopic('AppUpdateReminder');
  }
}
  
