import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';

import 'src/configs/configs.dart';
import 'src/presentation/app/app.dart';
import 'src/utils/http_remote.dart';
import 'src/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // final trace = FirebasePerformance.instance.newTrace('app_start');
  // await trace.start();
  // ConfigCrashlytics.init();
  // notificationInitialed();
  // await ConfigPerformance.init();
  await AppDeviceInfo.init();
  await HttpRemote.init();
  runApp(const MyApp());
  // await trace.stop();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
