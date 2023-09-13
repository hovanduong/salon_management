import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../intl/generated/l10n.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class CategoryAddViewModel extends BaseViewModel{
  bool enableButton=false;
  TextEditingController categoryController = TextEditingController();
  String? messageErorrCategory;
  AuthApi authApi= AuthApi();
  dynamic init(){}

  void validCategory(String? value) {
    if (value == null || value.isEmpty) {
      messageErorrCategory= ServiceAddLanguage.emptyNameError;
    }else if(value.length<2){
      messageErorrCategory=S.current.validName;
    }else{
      messageErorrCategory='';
    }
    notifyListeners();
  }

  void onSubmit() {
    if (messageErorrCategory == '' && categoryController.text!='') {
      enableButton = true;
    } else {
      enableButton = false;
    }
    notifyListeners();
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
          onTap: () => Navigator.pop(context),
        );
      },
    );
  }

  dynamic showErrorDiaglog(_){
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
        );
      },
    );
  }

  dynamic showSuccessDiaglog(_){
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
          onTap: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> postCategory(String name) async {
    final result = await authApi.postCategory(name);

    final value = switch (result) {
      Success(value: final isTrue) => isTrue,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDiaglog(context);
    } else {
      showSuccessDiaglog(context);
    }
    notifyListeners();
  }
}