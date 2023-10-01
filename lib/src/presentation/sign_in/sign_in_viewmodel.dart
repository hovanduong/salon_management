import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../../utils/http_remote.dart';
import '../base/base.dart';
import '../routers.dart';

class Constants {
  static const signInScreen = 'SignInScreen';
}

class SignInViewModel extends BaseViewModel {
  AuthApi authApi = AuthApi();

  bool enableSignIn = false;

  String? messagePhone;
  String? messagePass;

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  dynamic init() {}

  Future<void> goToSignUp() => Navigator.pushNamed(
        context,
        Routers.signUp,
      );

  Future<void> goToHome() =>
      Navigator.pushReplacementNamed(context, Routers.navigation);

  void validPhone(String? value) {
    final result = AppValid.validatePhoneNumber(value);
    if (result != null) {
      messagePhone = result;
    } else {
      messagePhone = null;
    }
    notifyListeners();
  }

  void validPass(String? value) {
    final result = AppValid.validatePassword(value);
    if (result != null) {
      messagePass = result;
    } else {
      messagePass = null;
    }
    notifyListeners();
  }

  void onSignIn() {
    if (messagePass == null &&
        messagePhone == null &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      enableSignIn = true;
    } else {
      enableSignIn = false;
    }
    notifyListeners();
  }

  dynamic showOpenDialog(_) {
    showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          content: SignInLanguage.validAccount,
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
          leftButtonName: SignUpLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: SignInLanguage.nowSignUp,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () {
            goToSignUp();
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

  Future<void> saveToken(String value) async {
    await AppPref.setToken(value);
  }

  void setEvenAnalytics(String? phoneNumber) {
    // ConfigAnalytics.signIn(phoneNumber!);
  }

  void setSignInScreen() {
    // ConfigAnalytics.setCurrentScreen(Constants.signInScreen);
  }

  String? handleNumberPhone(String? phone) {
    if (phone == null) {
      return null;
    }
    return phone.substring(1, phone.length);
  }

  Future<void> onLogin({String? phone, String? password}) async {
    // final phoneNumber = handleNumberPhone(phone);

    LoadingDialog.showLoadingDialog(context);
    final result = await authApi.login(
      AuthParams(
        phoneNumber: phone,
        password: password,
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
      setEvenAnalytics(phone);
      setSignInScreen();
      await saveToken(value.toString());
      await HttpRemote.init();
      await goToHome();
    }
  }
}
