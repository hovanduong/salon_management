import 'package:flutter/cupertino.dart';

import '../resource/service/service_model.dart';
import 'home_detail/home_detail_screen.dart';
import 'service_list/service_list.dart';

class AppRouter {
  static Future<void> goToServiceList(BuildContext context) => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const ServiceListScreen(),
        ),
      );

  static Future<void> goToHomeDetails(
    BuildContext context,
    int idService,
  ) =>
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => const HomeDetailScreen(),
            settings: RouteSettings(arguments: idService)),
      );
}
