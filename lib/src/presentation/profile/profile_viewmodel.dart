import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/profile_language.dart';
import '../../resource/model/model.dart';
import '../../utils/app_pref.dart';
import '../../utils/http_remote.dart';
import '../base/base.dart';
import '../routers.dart';

class ProfileViewModel extends BaseViewModel {
  UserModel? userModel;

  Future<void> init() async{
    await setDataUser();
  }

  Future<void> setDataUser()async{
    userModel = UserModel(
      email: await AppPref.getDataUSer('email') ?? '',
      fullName: await AppPref.getDataUSer('fullName') ?? '',
      gender: await AppPref.getDataUSer('gender') ?? '',
      id: int.parse(await AppPref.getDataUSer('id') ?? '0'),
      phoneNumber: await AppPref.getDataUSer('phoneNumber') ?? '',
    );
    notifyListeners();
  }

  Future<void> goToProfileAccount(BuildContext context) =>
      Navigator.pushNamed(context, Routers.profileAccount);

  Future<void> goToCategory(BuildContext context) =>
      Navigator.pushNamed(context, Routers.category);
  
  Future<void> goToNote(BuildContext context) =>
      Navigator.pushNamed(context, Routers.noteScreen);

  Future<void> goToSignIn(BuildContext context) =>
      Navigator.pushReplacementNamed(context, Routers.signIn);

  Future<void> goToMyCustomer(BuildContext context) =>
      Navigator.pushNamed(context, Routers.myCustomer);
  
  Future<void> goToPayment(BuildContext context) =>
      Navigator.pushNamed(context, Routers.payment);

  Future<void> logOut() async {
    await AppPref.logout();
    await HttpRemote.init();
    await goToSignIn(context);
  }

  Future<void> showLogOutPopup() async {
    await showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: ProfileLanguage.contentLogout,
          leftButtonName: SignUpLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: ProfileLanguage.logout,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async{
            await logOut();
          },
        );
      },
    );
  }
}
