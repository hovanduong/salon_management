import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/app_exception/app_exception.dart';
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
    if (value!.trim().isEmpty) {
      messageFullName = SignUpLanguage.validEnterFullName;
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
    if (messagePhone == null && phoneController.text!='' && messageFullName!=''
      && messageFullName==null && isPassword && isConfirmPass) {
      enableNext = true;
    } else {
      enableNext = false;
    }
    notifyListeners();
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: SignUpLanguage.exitApp,
          content: SignUpLanguage.exitAppContent,
          leftButtonName: SignUpLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: BookingLanguage.confirm,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
        );
      },
    )??false;
  }

  dynamic showOpenDialog(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          content: SignUpLanguage.signUpFail,
          image: AppImages.icPlus,
          title: SignUpLanguage.notification,
          leftButtonName: SignUpLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: SignInLanguage.tryAgain,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async{
            Navigator.pop(context);
            await signUp();
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
        goToSignIn();
      } 
    );
  }

  Future<void> saveToken(String value) async {
    await AppPref.setToken(value);
  }

  dynamic showOpenUserExits(_) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WarningDialog(
          content: SignUpLanguage.existsAccount,
          image: AppImages.icPlus,
          title: SignUpLanguage.notification,
          leftButtonName: SignUpLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: SignUpLanguage.signIn,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async {
            await goToSignIn();
          },
        );
      },
    );
  }

  Future<void> handleCustomerError(String message) async {
    if (message.trim() == AppValues.userExits) {
      LoadingDialog.hideLoadingDialog(context);
      await showOpenUserExits(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      await showOpenDialog(context);
    }
  }

  Future<void> signUp() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await authApi.signUp(AuthParams(
      email: 'email@gmail.com',
      fullName: fullNameController.text.trim(),
      gender: 'Nữ',
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
    } else if (value is AppException) {
      await handleCustomerError(value.message);
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
