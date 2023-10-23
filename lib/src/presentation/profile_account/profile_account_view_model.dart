import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/configs.dart';
import '../../resource/model/model.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../../utils/http_remote.dart';
import '../base/base.dart';
import '../routers.dart';

class ProfileAccountViewModel extends BaseViewModel {
  UserModel? userModel;
  late AuthApi authApi;

  TextEditingController phoneController = TextEditingController();
  late bool removeAccount = false;
  Timer? _timer;

  Future<void> init() async {
    authApi = AuthApi();
    await setDataUser();
  }

  Future<void> gotoChangePass() 
    => Navigator.pushNamed(context,Routers.changePassword,);

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

  dynamic showOpenDialogFail(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          content: ProfileAccountLanguage.accountInfo,
          image: AppImages.icPlus,
          title: ProfileAccountLanguage.notification,
          leftButtonName: ProfileAccountLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: ProfileAccountLanguage.contact,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async {
            final url = Uri(scheme: 'tel', path: '0944010499');
            await launchUrl(url);
          },
        );
      },
    );
  }

  Timer startDelaySignIn() => _timer = Timer(
        const Duration(seconds: 1),
        goToSignIn,
      );
  Future<void> goToSignIn() =>
      Navigator.pushReplacementNamed(context, Routers.signIn);

  dynamic showDialogRemoveAccountSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: ProfileAccountLanguage.deleteAccountSuccess,
        );
      },
    );
  }

  Future<void> deleteAccount() async {
    final phone = userModel!.phoneNumber!.trim();
    if (phone == phoneController.text.trim()) {
      final result = await authApi.deleteAccount();

      final value = switch (result) {
        Success(value: final data) => data,
        Failure(exception: final exception) => exception,
      };

      if (!AppValid.isNetWork(value)) {
        await showDialogNetwork(context);
      } else if (value is Exception) {
        await showOpenDialogFail(context);
      } else if (value is bool) {
        removeAccount = value;
      }
    } else {
      phoneController.clear();
      await showOpenDialogFail(context);
    }

    notifyListeners();
  }

  Future<void> logOut() async {
    await AppPref.logout();
    await HttpRemote.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    phoneController.dispose();
    super.dispose();
  }
}
