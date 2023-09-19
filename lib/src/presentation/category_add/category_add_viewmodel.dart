import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../intl/generated/l10n.dart';
import '../../resource/model/my_category_model.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/category_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class CategoryAddViewModel extends BaseViewModel {
  bool enableButton = false;
  TextEditingController categoryController = TextEditingController();
  String? messageErrorCategory;
  CategoryApi categoryApi = CategoryApi();
  CategoryModel? categoryModel;
  Future<void> init(CategoryModel? data) async {
    if (data != null) {
      categoryModel = data;
      categoryController.text = categoryModel!.name.toString();
      enableButton = true;
    }
  }

  void validCategory(String? value) {
    if (value == null || value.isEmpty) {
      messageErrorCategory = ServiceAddLanguage.emptyNameError;
    } else if (value.length < 2) {
      messageErrorCategory = S.current.validName;
    } else {
      messageErrorCategory = '';
    }
    notifyListeners();
  }

  void onSubmit() {
    if (messageErrorCategory == '' && categoryController.text != '') {
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

  Future<void> setSourceButton() async {
    if (categoryModel != null) {
      await putCategory();
      Timer(const Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } else {
      await postCategory(categoryController.text);
      categoryController.text = '';
      onSubmit();
    }
  }

  dynamic showErrorDialog(_) {
    showDialog(
      context: context,
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

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> postCategory(String name) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await categoryApi.postCategory(name);

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
      AuthParams(id: categoryModel!.id, name: categoryController.text),
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
}
