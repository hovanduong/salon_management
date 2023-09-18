import 'package:flutter/cupertino.dart';

import '../../utils/app_pref.dart';
import '../../utils/http_remote.dart';
import '../base/base.dart';
import '../routers.dart';

class ProfileViewModel extends BaseViewModel {
  dynamic init() {}

  Future<void> goToCategory(BuildContext context) =>
      Navigator.pushNamed(context, Routers.category);

  Future<void> goToSignIn(BuildContext context) =>
      Navigator.pushReplacementNamed(context, Routers.signIn);

  Future<void> logOut() async {
    await AppPref.logout();
    await HttpRemote.init();
    await goToSignIn(context);
  }
}
