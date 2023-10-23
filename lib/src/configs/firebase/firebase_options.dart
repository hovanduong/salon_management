// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBWmTZNpv9XuPfrm4penrN_FDiZl86E53M',
    appId: '1:665751697700:web:44f0d92f59bb8cc1f95bb1',
    messagingSenderId: '665751697700',
    projectId: 'spadev-64c7e',
    authDomain: 'spadev-64c7e.firebaseapp.com',
    storageBucket: 'spadev-64c7e.appspot.com',
    measurementId: 'G-FBCXZYXW8S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABvJk9RCujmSQ_KtohA-dvMsz6OkYFaZo',
    appId: '1:665751697700:android:45c18ed535c22a0bf95bb1',
    messagingSenderId: '665751697700',
    projectId: 'spadev-64c7e',
    storageBucket: 'spadev-64c7e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqBIO-yec2wWr1DxJJ0cGozYS2EeHqiOg',
    appId: '1:665751697700:ios:3e4ddec0ab8597d8f95bb1',
    messagingSenderId: '665751697700',
    projectId: 'spadev-64c7e',
    storageBucket: 'spadev-64c7e.appspot.com',
    iosClientId: '665751697700-1dik8gsbakqfv85l350ol6s21ene5unu.apps.googleusercontent.com',
    iosBundleId: 'com.example.bookingApp.RunnerTests',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCqBIO-yec2wWr1DxJJ0cGozYS2EeHqiOg',
    appId: '1:665751697700:ios:3e4ddec0ab8597d8f95bb1',
    messagingSenderId: '665751697700',
    projectId: 'spadev-64c7e',
    storageBucket: 'spadev-64c7e.appspot.com',
    iosClientId: '665751697700-1dik8gsbakqfv85l350ol6s21ene5unu.apps.googleusercontent.com',
    iosBundleId: 'com.example.bookingApp.RunnerTests',
  );
}
