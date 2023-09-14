import 'package:flutter/cupertino.dart';

import '../base/base.dart';
import '../routers.dart';

class ProfileViewModel extends BaseViewModel {
  dynamic init() {}

  Future<void> goToCategory(BuildContext context)
    => Navigator.pushNamed(context, Routers.createPassword);
}
