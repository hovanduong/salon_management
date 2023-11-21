// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/category_language.dart';
import '../../configs/language/my_customer_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';
import '../../resource/service/my_customer_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class MyCustomerViewModel extends BaseViewModel {
  MyCustomerApi myCustomerApi = MyCustomerApi();
  ScrollController scrollController = ScrollController();

  List<MyCustomerModel> listMyCustomer = [];
  List<MyCustomerModel> listCurrent = [];
  List<MyCustomerModel> newListCustomer = [];

  bool isLoading = true;
  bool loadingMore = false;

  Timer? timer;

  int page = 1;

  Future<void> init() async {
    page = 1;
    isLoading = true;
    await getMyCustomer(page, false);
    scrollController.addListener(scrollListener);
    notifyListeners();
  }

  Future<void> goToAddMyCustomer(BuildContext context) =>
      Navigator.pushNamed(context, Routers.myCustomerAdd);

  Future<void> goToMyCustomerEdit(
    BuildContext context,
    MyCustomerModel myCustomerModel,
  ) =>
      Navigator.pushNamed(
        context,
        Routers.myCustomerEdit,
        arguments: myCustomerModel,
      );

  Future<void> onSearchCategory(String value) async {
    // final searchCustomer = TiengViet.parse(value.toLowerCase());
    final searchCustomer= value;
    await getListSearch(searchCustomer);
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    page += 1;
    await getMyCustomer(page, true);
    listMyCustomer = [...listMyCustomer, ...newListCustomer];
    notifyListeners();
  }

  dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      loadingMore = true;
      Future.delayed(const Duration(seconds: 2), () {
        loadMoreData();
        loadingMore = false;
      });
      notifyListeners();
    }
  }

  Future<void> pullRefresh() async {
    await init();
    notifyListeners();
  }

  dynamic showDialogNetwork(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          content: MyCustomerLanguage.errorNetwork,
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

  dynamic showDialogStatus(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          image: AppImages.icPlus,
          content: '',
          title: 'title',
          leftButtonName: SignUpLanguage.cancel,
          rightButtonName: HistoryLanguage.confirmed,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          onTapLeft: () => Navigator.pop(context),
          onTapRight: () async {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  dynamic showWaningDiaglog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: MyCustomerLanguage.waningDeleteCustomer,
          leftButtonName: SignUpLanguage.cancel,
          onTapLeft: () {
            Navigator.pop(context);
          },
          rightButtonName: CategoryLanguage.confirm,
          onTapRight: () {
            deleteMyCustomer(id);
            Navigator.pop(context);
          },
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

  dynamic showSuccessDiaglog(_) {
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

  void closeDialog(BuildContext context) {
    timer = Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> getMyCustomer(int page, bool isNewList) async {
    final result = await myCustomerApi.getMyCustomer(
      getAll: false,
      page: page,
    );

    final value = switch (result) {
      Success(value: final listMyCustomer) => listMyCustomer,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading = true;
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      if (isNewList) {
        newListCustomer = value as List<MyCustomerModel>;
      } else {
        listMyCustomer = value as List<MyCustomerModel>;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteMyCustomer(int id) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await myCustomerApi.deleteMyCustomer(id);

    final value = switch (result) {
      Success(value: final isTrue) => isTrue,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      await pullRefresh();
      showSuccessDiaglog(context);
    }
    notifyListeners();
  }

  Future<void> getListSearch(String? search) async {
    final result = await myCustomerApi.getMyCustomer(
      getAll: false,
      page: page,
      search: search,
    );

    final value = switch (result) {
      Success(value: final listMyCustomer) => listMyCustomer,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading = true;
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      listMyCustomer = value as List<MyCustomerModel>;
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
