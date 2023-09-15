// import 'package:firebase_analytics/firebase_analytics.dart';

// class Constants {
//   static const signIn = 'SignIn';
//   static const phoneNumber = 'PhoneNumber';
// }

// class ConfigAnalytics {
//   static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//   static FirebaseAnalyticsObserver observer =
//       FirebaseAnalyticsObserver(analytics: analytics);

//   static Future<void> setCurrentScreen(String screenName) async {
//     await analytics.setCurrentScreen(screenName: screenName);
//   }

//   static void signIn(String phoneNumber) {
//     analytics.logEvent(
//       name: Constants.signIn,
//       parameters: <String, dynamic>{
//         Constants.phoneNumber: phoneNumber,
//       },
//     );
//   }
// }
