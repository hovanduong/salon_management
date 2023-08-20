import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class VerificationViewModel extends BaseViewModel {
  dynamic init() {}

  String? messageVerifycation;
  bool enableNext = false;
  String code='';
  AuthApi authApi = AuthApi();

  Future<void> goToSignIn() async{
    Timer(const Duration(seconds: 3),
     () => Navigator.pushReplacementNamed(context, Routers.signIn),);
  } 



  void validateVerificationCode(String? value) {
    final result = AppValid.validateVerificationCode(value);
    if (result != null) {
      messageVerifycation = result;
    } else  {
      messageVerifycation = null;
    }
    notifyListeners();
  }

  void onNext() {
    if (messageVerifycation == null) {
      enableNext = true;
    } else {
      enableNext = false;
    }
    print(enableNext);
    notifyListeners();
  }

  dynamic showOpenDialog(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          onTap: () {
            Navigator.pop(context);
          },
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
          color: AppColors.BLACK_500,
          content: SignUpLanguage.validOTP,
          colorNameLeft: AppColors.BLACK_500,
          buttonName: SignUpLanguage.cancel,
        );
      },
    );
  }

  dynamic showOpenSuccessDialog(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          onTap: () {
            Navigator.pop(context);
          },
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
          color: AppColors.BLACK_500,
        );
      },
    );
  }

  dynamic showOpenDialogNetwork(_) {
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

  Future<void> onSignUp(RegisterArguments args) async {
    final result = await authApi.signUp(
      AuthParams(
        user: args.userModel,
        password: args.pass,
      ),
    );

    final value = switch (result) {
      Success(value: final data) => data,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      showOpenDialogNetwork(context);
    } else if (value is Exception) {
      // showOpenDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      showOpenSuccessDialog(context);
      await FirebaseFirestore.instance.collection('phone')
          .add({'phone':args.userModel!.phone});
      await goToSignIn();
    }
  }

  Future<void> checkOTP(RegisterArguments args)async{
    LoadingDialog.showLoadingDialog(context);
    final credential = PhoneAuthProvider.credential(
      verificationId: args.verificationId.toString(), 
      smsCode: code,
    );
    await FirebaseAuth.instance.signInWithCredential(credential)
    .then((value){
       onSignUp(args);
    })
    .catchError((onError){
      LoadingDialog.hideLoadingDialog(context);
      showOpenDialog(context);
    });
  }
}
