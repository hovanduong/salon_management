import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/my_customer_edit_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';
import '../../resource/service/my_customer_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class MyCustomerEditViewModel extends BaseViewModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  String selectedGender=MyCustomerEditLanguage.male;

  String? messageErrorName;
  String? messageErrorMail;
  int? id;

  List<CategoryModel> listCategory = <CategoryModel>[];

  MyCustomerApi myCustomerApi = MyCustomerApi();

  bool isColorProvinces = false;
  bool enableSubmit = false;

  Timer? timer;

  Future<void> init(MyCustomerModel myCustomerModel) async {
    setData(myCustomerModel);
    notifyListeners();
  }

  void setData(MyCustomerModel myCustomerModel){
    id= myCustomerModel.id;
    nameController.text= myCustomerModel.fullName!;
    if(myCustomerModel.email!=null){
      mailController.text= myCustomerModel.email!;
    }
    onSubmit();
  }

  void setSelectedGender(String gender){
    selectedGender= gender;
    notificationInitialed();
  }

  void validName(String? value) {
    final result = AppValid.validateName(value);
    if (result != null) {
      messageErrorName = result;
    } else {
      messageErrorName = null;
    }
    notifyListeners();
  }

  void validMail(String? value) {
    final result = AppValid.validateEmail(value);
    if (result != null) {
      messageErrorMail = result;
    } else {
      messageErrorMail = null;
    }
    notifyListeners();
  }

  void onSubmit() {
    if (messageErrorName == null &&
        nameController.text != '' &&
        mailController.text != '' &&
        messageErrorMail== null ) {
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
          content: MyCustomerEditLanguage.errorNetwork,
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

  void closeDialog(BuildContext context){
    Timer(const Duration(seconds: 1), () => Navigator.pop(context),);
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
          onTap: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> putMyCustomer() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await myCustomerApi.putMyCustomer(
      MyCustomerParams(
        id: id,
        email: mailController.text,
        fullName: nameController.text,
        gender: 'Nữ',
      ),
    );

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
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
      showSuccessDialog(context);
      timer= Timer(const Duration(seconds: 2), () {Navigator.pop(context); });
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
