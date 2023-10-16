import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class CreatePasswordViewModel extends BaseViewModel {
  bool enableCreatePass = false;
  String? messageConfirmPass;
  String? messagePass;
  bool isPassword = false;
  bool isConfirmPass = false;
  AuthApi authApi= AuthApi();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  dynamic init() {}

  Future<void> goToVerification(
    RegisterArguments infoUser,
    String verificationId,
  ) =>
      Navigator.pushNamed(context, Routers.verification,
          arguments: RegisterArguments(
            pass: passController.text,
            verificationId: verificationId,
            userModel: infoUser.userModel,
          ),);

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

  void onCreatePass() {
    if (isPassword && isConfirmPass) {
      enableCreatePass = true;
    } else {
      enableCreatePass = false;
    }
    notifyListeners();
  }

  dynamic showDialogNetWork(_) {
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

  dynamic showDialogPass(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          content: CreatePasswordLanguage.warningCreatePass,
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

  // Future<void> sendOTP(RegisterArguments infoUser) async {
  //   LoadingDialog.showLoadingDialog(context);
  //   final result = await authApi.sendOTP(
  //     AuthParams(
  //       userModel: infoUser.userModel,
  //       password: passController.text,
  //     ),
  //     context,
  //   );

  //   final value = switch (result) {
  //     Success(value: final verificationId) => verificationId,
  //     Failure(exception: final exception) => exception,
  //   };

  //   if(!AppValid.isNetWork(value)){
  //     LoadingDialog.hideLoadingDialog(context);
  //     showDialogNetWork(context);
  //   }
  // }
}
