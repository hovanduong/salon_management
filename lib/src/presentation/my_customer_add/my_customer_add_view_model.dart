// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/app_exception/app_exception.dart';
import '../../configs/configs.dart';
import '../../configs/language/my_customer_add_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/my_customer_model.dart';
import '../../resource/service/my_customer_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class MyCustomerAddViewModel extends BaseViewModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? messageErrorName;
  String? messageErrorPhone;

  MyCustomerApi myCustomerApi = MyCustomerApi();

  bool isColorProvinces = false;
  bool enableSubmit = false;
  bool isPayments = false;

  Timer? timer;

  Future<void> init(bool isPayment) async {
    isPayments = isPayment;
  }

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> _goToHome() =>
      Navigator.pushReplacementNamed(context, Routers.navigation);

  void validName(String? value) {
    if (value!.trim().isEmpty || value.trim()=='') {
      messageErrorName = SignUpLanguage.validEnterFullName;
    } else {
      messageErrorName = null;
    }
    notifyListeners();
  }

  void validPhone(String? value) {
    final result = AppValid.validatePhoneNumber(value);
    if (result != null) {
      messageErrorPhone = result;
    } else {
      messageErrorPhone = null;
    }
    notifyListeners();
  }

  void onSubmit() {
    if (messageErrorName == null &&
        nameController.text != '' &&
        phoneController.text != '' &&
        messageErrorPhone == null) {
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
          content: MyCustomerAddLanguage.errorNetwork,
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

  dynamic showSuccessDialog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: MyCustomerAddLanguage.addSuccess,
        );
      },
    );
  }

  void clearData() {
    if(!isPayments){
      nameController.text = '';
      phoneController.text = '';
    }
    notifyListeners();
  }

  void closeScreen() {
    if (isPayments == true) {
      timer = Timer(const Duration(seconds: 2), () => 
        Navigator.pop(context, MyCustomerModel(
          fullName: nameController.text.trim(),
          phoneNumber: phoneController.text.trim(),
        ),),);
    }
  }

  dynamic showOpenCustomerExits(_) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WarningDialog(
          content: MyCustomerAddLanguage.phoneNumberExists,
          image: AppImages.icPlus,
          title: MyCustomerAddLanguage.notification,
          leftButtonName: MyCustomerAddLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: MyCustomerAddLanguage.home,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async {
            await _goToHome();
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
          content: MyCustomerAddLanguage.addCustomerFailed,
          image: AppImages.icPlus,
          title: MyCustomerAddLanguage.notification,
          leftButtonName: MyCustomerAddLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: MyCustomerAddLanguage.tryAgain,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async {
            Navigator.pop(context);
            await postMyCustomer();
          },
        );
      },
    );
  }

  Future<void> handleCustomerError(String message) async {
    if (message.trim() == AppValues.customerExits) {
      LoadingDialog.hideLoadingDialog(context);
      await showOpenCustomerExits(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      await showOpenDialog(context);
    }
  }

  Future<void> postMyCustomer() async {
    LoadingDialog.showLoadingDialog(context);

    final result = await myCustomerApi.postMyCustomer(
      MyCustomerParams(
        phoneNumber: phoneController.text,
        fullName: nameController.text,
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
      await handleCustomerError(value.message);
    } else if (value is bool) {
      if (value) {
        LoadingDialog.hideLoadingDialog(context);
        await showSuccessDialog(context);
        clearData();
        closeScreen();
      } else {
        LoadingDialog.hideLoadingDialog(context);
        await showOpenDialog(context);
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
