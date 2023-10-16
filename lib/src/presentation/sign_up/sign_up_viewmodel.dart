import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../../utils/http_remote.dart';
import '../base/base.dart';
import '../routers.dart';

class SignUpViewModel extends BaseViewModel {
  AuthApi authApi = AuthApi();

  bool enableNext = false;
  bool isPassword = false;
  bool isConfirmPass = false;

  String? messageConfirmPass;
  String? messagePass;
  String? messagePhone;
  String? messageFullName;
  String? messageEmail;
  String? gender;

  TextEditingController fullNameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController phoneController= TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  dynamic init() {
    gender= genderList.first;
  }

  List<String> genderList = [
    UpdateProfileLanguage.male,
    UpdateProfileLanguage.female,
    UpdateProfileLanguage.other,
  ];

  Future<void> goToSignIn() =>
      Navigator.pushReplacementNamed(context, Routers.signIn);
      
  Future<void> goToHome() 
    => Navigator.pushReplacementNamed(context, Routers.navigation);

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void validConfirmPass(String? confirmPass, String? pass) {
    final result = AppValid.validatePasswordConfirm(pass!, confirmPass);
    if (result != null) {
      messageConfirmPass = result;
      isConfirmPass = false;
    } else {
      messageConfirmPass = null;
      isConfirmPass = true;
    }
    notifyListeners();
  }

  void validPass(String? value, String? confirmPass) {
    final result = AppValid.validatePassword(value);
    if (result != null) {
      messagePass = result;
      isPassword = false;
    } else {
      messagePass = null;
      isPassword = true;
    }
    if (confirmPass!.isNotEmpty) {
      final result = AppValid.validatePasswordConfirm(value!, confirmPass);
      if (result != null) {
        messageConfirmPass = result;
        isConfirmPass = false;
      } else {
        messageConfirmPass = null;
        isConfirmPass = true;
      }
    }
    notifyListeners();
  }

  void validPhone(String? value) {
    final result = AppValid.validatePhoneNumber(value);
    if (result != null) {
      messagePhone = result;
    } else {
      messagePhone = null;
    }
    notifyListeners();
  }

  void validFullName(String? value) {
    final result = AppValid.validateFullName(value);
    if (result != null) {
      messageFullName = result;
    } else {
      messageFullName = null;
    }
    notifyListeners();
  }

  void validEmail(String? value) {
    final result = AppValid.validateEmail(value);
    if (result != null) {
      messageEmail = result;
    } else {
      messageEmail = null;
    }
    notifyListeners();
  }

  void onSignUp() {
    if (messagePhone == null && messageEmail==null
      && messageFullName==null && isPassword && isConfirmPass) {
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

  dynamic showSuccessDiaglog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
        );
      },
    );
  }

  Future<void> closeDialog(BuildContext context) async{
    Future.delayed(
      const Duration(seconds: 1),
      () {
        Navigator.pop(context);
        login();
      } 
    );
  }

  Future<void> saveToken(String value) async {
    await AppPref.setToken(value);
  }

  Future<void> signUp() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await authApi.signUp(AuthParams(
      email: emailController.text.trim(),
      fullName: fullNameController.text.trim(),
      gender: gender,
      password: passController.text.trim(),
      passwordConfirm: confirmPassController.text.trim(),
      phoneNumber: phoneController.text.trim(),
    ),);

    final value = switch (result) {
      Success(value: final boolean) => boolean,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      await showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      await showOpenDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      showSuccessDiaglog(context);
    }
    notifyListeners();
  }

  Future<void> login() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await authApi.login(AuthParams(
      phoneNumber: phoneController.text.trim(),
      password: passController.text.trim(),
    ),);

    final value = switch (result) {
      Success(value: final accessToken) => accessToken,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      await showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      await showOpenDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      await saveToken(value.toString());
      await HttpRemote.init();
      await goToHome();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
