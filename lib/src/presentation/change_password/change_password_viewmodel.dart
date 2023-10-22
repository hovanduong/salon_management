import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/app_exception/app_exception.dart';
import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class ChangePasswordViewModel extends BaseViewModel {
  String? messageConfirmPass;
  String? messageOldPass;
  String? messageNewPass;

  bool isOldPassword = false;
  bool isNewPassword = false;
  bool isConfirmPass = false;
  bool enableButton = false;
  
  AuthApi authApi= AuthApi();

  TextEditingController passOldController = TextEditingController();
  TextEditingController passNewController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  dynamic init() {}

  Future<void> goToHome() =>
      Navigator.pushReplacementNamed(context, Routers.navigation);

  void validPassOld(String? passOld, String? passNew){
    final result= AppValid.validatePassword(passOld);
    if (result!=null) {
      messageOldPass=result;
      isOldPassword=false;
    }else{
      messageOldPass=null;
      isOldPassword=true;
    }
    if (passNew!.isNotEmpty) {
      final result = AppValid.validateChangePass(passOld!, passNew);
      if (result != null) {
        messageNewPass = result;
        isNewPassword = false;
      } else {
        messageNewPass = null;
        isNewPassword = true;
      }
    }
  }

  void validPass(String? value, String? confirmPass, String? passOld) {
    final result = AppValid.validatePassword(value);
    if (result != null) {
      messageNewPass = result;
      isNewPassword = false;
    } else {
      messageNewPass = null;
      isNewPassword = true;
      if(passOld!.isNotEmpty){
        final result = AppValid.validateChangePass(passOld, value);
        if (result != null) {
          messageNewPass = result;
          isNewPassword = false;
        } else {
          messageNewPass = null;
          isNewPassword = true;
        }
      }
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

  void onEnable() {
    if (isNewPassword && isConfirmPass && isOldPassword) {
      enableButton = true;
    } else {
      enableButton = false;
    }
    notifyListeners();
  }

  dynamic showDialogNetWork(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          content: ChangePasswordLanguage.errorNetwork,
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

  void clearData() {
    passNewController.text = '';
    passOldController.text = '';
    confirmPassController.text='';
    notifyListeners();
  }

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pop(context),
    );
  }

  dynamic showSuccessDiaglog(_) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WarningDialog(
          content: ChangePasswordLanguage.changePassSuccess,
          image: AppImages.icCheck,
          title: ChangePasswordLanguage.success,
          leftButtonName: ChangePasswordLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: ChangePasswordLanguage.home,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async {
            await goToHome();
          },
        );
      },
    );
  }

  dynamic showOpenPassOldError(_) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WarningDialog(
          content: ChangePasswordLanguage.oldPassWrong,
          image: AppImages.icPlus,
          title: ChangePasswordLanguage.notification,
          leftButtonName: ChangePasswordLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: ChangePasswordLanguage.home,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async {
            await goToHome();
          },
        );
      },
    );
  }

  dynamic showOpenDialog(_) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WarningDialog(
          content: ChangePasswordLanguage.changePassFail,
          image: AppImages.icPlus,
          title: ChangePasswordLanguage.failed,
          leftButtonName: ChangePasswordLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: ChangePasswordLanguage.tryAgain,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async {
            Navigator.pop(context);
            await changePassword();
          },
        );
      },
    );
  }

  Future<void> handlePassOldError(String message) async {
    print(message);
    if (message.trim() == AppValues.oldPassInvalid) {
      LoadingDialog.hideLoadingDialog(context);
      await showOpenPassOldError(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      await showOpenDialog(context);
    }
  }

  Future<void> changePassword() async {
    LoadingDialog.showLoadingDialog(context);

    final result = await authApi.changePassword(
      AuthParams(
        oldPass: passOldController.text.trim(),
        password: passNewController.text.trim(),
      ),
    );

    final value = switch (result) {
      Success(value: final listCustomer) => listCustomer,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      await showDialogNetwork(context);
    } else if (value is AppException) {
      await handlePassOldError(value.message);
    } else if (value is bool) {
      LoadingDialog.hideLoadingDialog(context);
      clearData();
      await showSuccessDiaglog(context);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    passNewController.dispose();
    passOldController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}
