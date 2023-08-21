import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../configs/firebase/analytics_firebase.dart';
import '../../intl/generated/l10n.dart';

import '../routers.dart';
import '../service_add/add_service.dart';
import '../statistics/statistics_screen.dart';

class Constants {
  static const String languageVietName = 'vi';
  static const String countryVN = 'VN';
  static const String languageEnglish = 'en';
  static const String countryEnglish = 'US';
  static const String defaultLanguage = 'defaultLanguage';
  static const String fonts = 'Inter';
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: key,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [ConfigAnalytics.observer],
      theme: ThemeData(fontFamily: Constants.fonts),
      builder: (context, widget) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: widget!,
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      // locale: AppPref.isCheckLocale == _Contants.defaultLanguage
      //     ? window.locale
      //     : AppPref.isCheckLocale == _Contants.languageVietName
      //         ? const Locale(_Contants.languageVietName, _Contants.countryVN)
      //         : const Locale(
      //             _Contants.languageEnglish,
      //             _Contants.countryEnglish,
      //           ),
      // initialRoute: Routers.getStarted,
      // onGenerateRoute: Routers.generateRoute,
      home: const StaticticsScreen(),
    );
  }
}
