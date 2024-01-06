import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../intl/generated/l10n.dart';
import '../routers.dart';

class Constants {
  static const String languageVietName = 'vi';
  static const String countryVN = 'VN';
  static const String languageEnglish = 'en';
  static const String countryEnglish = 'US';
  static const String defaultLanguage = 'defaultLanguage';
  static const String fonts = 'Inter';
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      key: key,
      debugShowCheckedModeBanner: false,
      // navigatorObservers: [ConfigAnalytics.observer],
      theme: ThemeData(
        fontFamily: Constants.fonts,
        primarySwatch: Colors.green,
      ),
      builder: (context, widget) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: widget!,

      ),
      // builder: (context, widget) {
      //   final mediaQuery = MediaQuery.of(context);
      //   var paddingBottom = 50.0;
      //   var paddingRight = 0.0;
      //   if (mediaQuery.orientation == Orientation.landscape) {
      //     paddingBottom = 0.0;
      //     paddingRight = 50.0;
      //   }
      //   return Padding(
      //     padding: EdgeInsets.only(bottom: paddingBottom, right: paddingRight),
      //     child: widget,
      //   );
      // },
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
      initialRoute: Routers.getStarted,
      onGenerateRoute: Routers.generateRoute,
    );
  }
}
