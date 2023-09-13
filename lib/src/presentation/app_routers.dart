import 'package:flutter/cupertino.dart';

import '../resource/model/service_model.dart';
import 'add_service_category/add_service_category.dart';
import 'category/category.dart';
import 'category_add/category_add.dart';
import 'home_detail/home_detail_screen.dart';
import 'service_add/add_service.dart';
import 'service_details/service_details.dart';
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

  static Future<void> goToCategory(BuildContext context) => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const CategoryScreen(),
        ),
      );

  static Future<void> goToAddService(BuildContext context) => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const ServiceAddScreen(),
        ),
      );

  static Future<void> goToAddServiceCategory(BuildContext context) => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const AddServiceCategoriesScreen(),
        ),
      );

  static Future<void> goToCategoryAdd(BuildContext context) => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => const CategoryAddScreen(),
        ),
      );
}
