import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/category_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/my_category_model.dart';
import '../../resource/service/category_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class CategoryAddViewModel extends BaseViewModel {
  bool enableButton = false;
  bool isButtonExpenses=false;
  
  TextEditingController categoryController = TextEditingController();

  String? messageErrorCategory;

  Timer? timer;

  CategoryApi categoryApi = CategoryApi();

  CategoryModel? categoryModel;

  int? selectedCategory;

  Future<void> init(CategoryModel? data) async {
    selectedCategory=0;
    if (data != null) {
      categoryModel = data;
      categoryController.text = categoryModel!.name.toString();
      enableButton = true;
    }
    notifyListeners();
  }

  void setSelectIconCategory(int index){
    selectedCategory=index;
    notifyListeners();
  }

  void setButtonSelect(String name){
    if(name==CategoryLanguage.income){
      isButtonExpenses=false;
    }else{
      isButtonExpenses=true;
    }
    notifyListeners();
  }

  void validCategory(String? value) {
    final result = AppValid.validateCategory(value);
    if (result != null) {
      messageErrorCategory = result;
    } else {
      messageErrorCategory = null;
    }
    notifyListeners();
  }

  void onSubmit() {
    if (messageErrorCategory == null && categoryController.text != '') {
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
          content: CategoryLanguage.errorNetwork,
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

  Future<void> setSourceButton() async {
    if (categoryModel != null) {
      await putCategory();
    } else {
      await postCategory();
      categoryController.text = '';
      onSubmit();
    }
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

  dynamic showSuccessDiaglog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.addSuccess,
        );
      },
    );
    timer= Timer(const Duration(seconds: 2), () {Navigator.pop(context);});
  }

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> postCategory() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await categoryApi.postCategory(
      CategoryParams(
        imageId: selectedCategory,
        income: !isButtonExpenses,
        name: categoryController.text.trim(),
      ),
    );

    final value = switch (result) {
      Success(value: final isTrue) => isTrue,
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
      await showSuccessDiaglog(context);
    }
    notifyListeners();
  }

  Future<void> putCategory() async {
    LoadingDialog.showLoadingDialog(context);

    final result = await categoryApi.putCategory(
      CategoryParams(id: categoryModel!.id, name: categoryController.text),
    );

    final value = switch (result) {
      Success(value: final isTrue) => isTrue,
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
      await showSuccessDiaglog(context);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
