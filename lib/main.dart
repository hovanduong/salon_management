import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upgrader/upgrader.dart';

import 'src/configs/configs.dart';
import 'src/presentation/app/app.dart';
import 'src/utils/http_remote.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final trace = FirebasePerformance.instance.newTrace('app_start');
  await trace.start();
  await MobileAds.instance.initialize();
  await Upgrader.clearSavedSettings();
  await HttpRemote.init();
  ConfigCrashlytics.init();
  notificationInitialed();
  await ConfigPerformance.init();
  await AppDeviceInfo.init();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const MyApp());
  await trace.stop();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

