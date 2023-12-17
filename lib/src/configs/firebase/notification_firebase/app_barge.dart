import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import '../../../utils/utils.dart';

class AppBarge {
  static Future<void> addBarge() async {
    final userId = await AppPref.getDataUSer('id');
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
        if (count == 0 || count == null) {
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
