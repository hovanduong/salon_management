import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/my_customer_add_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/my_customer_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class MyCustomerAddViewModel extends BaseViewModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String messageErrorName = '';
  String? messageErrorPhone;

  MyCustomerApi myCustomerApi = MyCustomerApi();

  bool isColorProvinces = false;
  bool enableSubmit = false;

  Future<void> init() async {

  }

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pop(context),
    );
  }

  void validName(String? value) {
    if (value == null || value.isEmpty) {
      messageErrorName = MyCustomerAddLanguage.emptyFullNameError;
    }else {
      messageErrorName = '';
    }
    notifyListeners();
  }

  void validPhone(String? value) {
    final result = AppValid.validPhone(value);
    if (result != null) {
      messageErrorPhone = result;
    } else {
      messageErrorPhone = null;
    }
    notifyListeners();
  }

  void onSubmit() {
    if (messageErrorName == '' &&
        nameController.text != '' &&
        phoneController.text != '' &&
        messageErrorPhone== null ) {
      enableSubmit = true;
    } else {
      enableSubmit = false;
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

  dynamic showErrorDialog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
        );
      },
    );
  }

  dynamic showSuccessDialog(_) {
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

  void clearData() {
    nameController.text = '';
    phoneController.text = '';
    notifyListeners();
  }

  Future<void> postMyCustomer() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await myCustomerApi.postMyCustomer(
      AuthParams(
        phoneNumber: phoneController.text,
        name: nameController.text
      ),
    );

    final value = switch (result) {
      Success(value: final listCustomer) => listCustomer,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      await showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      await showErrorDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      clearData();
      await showSuccessDialog(context);
    }
    notifyListeners();
  }
}
