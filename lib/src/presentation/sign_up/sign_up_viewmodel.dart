import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class SignUpViewModel extends BaseViewModel {
  AuthApi authApi = AuthApi();
  bool enableNext = false;
  String? messagePhone;
  String? phone;
  dynamic init() {}

  Future<void> goToProfileUpdate() =>
      Navigator.pushNamed(context, Routers.updateProfile, arguments: phone);

  Future<void> goToSignIn() =>
      Navigator.pushReplacementNamed(context, Routers.signIn);

  void validPhone(String? value) {
    final result = AppValid.validatePhoneNumber(value);
    if (result != null) {
      messagePhone = result;
    } else {
      messagePhone = null;
    }
    notifyListeners();
  }

  void onNext() {
    if (messagePhone == null) {
      enableNext = true;
    } else {
      enableNext = false;
    }
    notifyListeners();
  }

  dynamic showOpenDialog(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          content: SignUpLanguage.existsAccount,
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
          leftButtonName: SignUpLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: SignInLanguage.signIn,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () {
            goToSignIn();
          },
        );
      },
    );
  }

  dynamic showDialogNetwork(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          content: CreatePasswordLanguage.errorNetwork,
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
          buttonName: SignUpLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          onTap: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> checkPhoneExists() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await authApi.checkPhoneNumberExists(
      AuthParams(
        phoneNumber: phone,
      ),
    );

    final value = switch (result) {
      Success(value: final accessToken) => accessToken,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      showOpenDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      await goToProfileUpdate();
    }
  }
}
