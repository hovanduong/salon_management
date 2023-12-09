import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/my_category_model.dart';
import '../../resource/model/radio_model.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/category_api.dart';
import '../../resource/service/my_service_api.dart';
import '../../utils/app_currency.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class ServiceAddViewModel extends BaseViewModel {
  TextEditingController nameServiceController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Map<int, String> mapCategory = {};

  String? messageErrorNameService;
  String messageErrorPrice = '';

  List<CategoryModel> listCategory = <CategoryModel>[];
  List<RadioModel> selectedCategory = [];
  List<bool> listIsCheck = [];
  List<int> categoryId = [];

  Timer? timer;

  AuthApi authApi = AuthApi();
  CategoryApi categoryApi = CategoryApi();
  MyServiceApi myServiceApi = MyServiceApi();

  bool isColorProvinces = false;
  bool enableSubmit = false;

  String? money;

  static const _locale = 'en';

  String formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  Future<void> init() async {
    await getCategory();
    await initMapCategory();
  }

  void formatMoney(String? value) {
    if (value != null && value.isNotEmpty) {
      final valueFormat =
          AppCurrencyFormat.formatNumberEnter(value.replaceAll(',', ''));
      priceController.value = TextEditingValue(
        text: valueFormat,
        selection: TextSelection.collapsed(offset: valueFormat.length),
      );
    }
    notifyListeners();
  }

  void closeDialog(BuildContext context) {
    timer = Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> changeValueCategory(List<RadioModel> value) async {
    selectedCategory.clear();
    selectedCategory = value;
    notifyListeners();
  }

  Future<void> setCategoryId() async {
    categoryId.clear();
    if (selectedCategory.isNotEmpty) {
      selectedCategory.forEach((element) {
        categoryId.add(element.id!);
      });
    }
    notifyListeners();
  }

  Future<void> initMapCategory() async {
    listCategory.forEach((element) {
      mapCategory.addAll(
        {element.id!: '${element.name}'},
      );
    });
    notifyListeners();
  }

  void removeCategory(int index) {
    selectedCategory.removeAt(index);
    notifyListeners();
  }

  void validNameService(String? value) {
    final result = AppValid.validateServiceName(value);
    if (result != null) {
      messageErrorNameService = result;
    } else {
      messageErrorNameService = null;
    }
    notifyListeners();
  }

  void validPrice(String? value) {
    money = value;
    if (value == null || value.isEmpty) {
      messageErrorPrice = ServiceAddLanguage.emptyMoneyError;
    } else {
      messageErrorPrice = '';
    }
    notifyListeners();
  }

  void onSubmit() {
    if (messageErrorNameService == null &&
        nameServiceController.text != '' &&
        priceController.text != '' &&
        messageErrorPrice == '' &&
        selectedCategory.isNotEmpty) {
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
          content: ChangePasswordLanguage.errorNetwork,
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

  Future<void> getCategory() async {
    listCategory.clear();
    final result = await categoryApi.getListCategory(const CategoryParams(
      page: 1, isUser: 0
    ),);

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      // await showDialogNetwork(context);
    } else if (value is Exception) {
      // await showErrorDialog(context);
    } else {
      listCategory = value as List<CategoryModel>;
    }
    notifyListeners();
  }

  void clearData() {
    nameServiceController.text = '';
    priceController.text = '';
    selectedCategory.clear();
    categoryId.clear();
    notifyListeners();
  }

  Future<void> postService() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await myServiceApi.postService(
      ServiceParams(
        name: nameServiceController.text,
        money: int.parse(money ?? '0'),
        listCategory: categoryId,
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
      clearData();
      await showSuccessDialog(context);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
