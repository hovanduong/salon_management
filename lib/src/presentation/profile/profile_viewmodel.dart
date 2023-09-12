import 'package:flutter/cupertino.dart';

import '../app_routers.dart';
import '../base/base.dart';

class ProfileViewModel extends BaseViewModel {
  dynamic init() {}

  Future<void> goToCategory(BuildContext context)
    => AppRouter.goToCategory(context);
}
