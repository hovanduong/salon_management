// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/category_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/my_category_model.dart';
import '../../resource/service/category_api.dart';
import '../../resource/service/my_service_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class CategoryViewModel extends BaseViewModel {
  CategoryApi categoryApi = CategoryApi();
  MyServiceApi myServiceApi = MyServiceApi();
  TextEditingController category = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<CategoryModel> listCategory = [];
  // List<CategoryModel> allCategory = [];
  List<CategoryModel> newListCategory = [];

  bool isIconFloatingButton = true;
  bool isLoading = true;
  bool loadingMore = false;
  bool isLoadingList = true;

  Timer? timer;

  int page = 1;

  Future<void> init() async {
    page = 1;
    await getCategory(page, false);
    isLoading = false;
    isLoadingList = false;
    scrollController.addListener(scrollListener);

    notifyListeners();
  }

  Future<void> pullRefresh() async {
    listCategory.clear();
    isLoadingList = true;
    await init();
    notifyListeners();
  }

  Future<void> onSearchCategory(String value) async {
    await getCategory(page, false, search: value.trim());
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    page += 1;
    await getCategory(page, true);
    listCategory = [...listCategory, ...newListCategory];
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

  Future<void> goToAddServiceCategory(BuildContext context) =>
      Navigator.pushNamed(context, Routers.addService);

  Future<void> goToUpdateServiceCategory(BuildContext context) =>
      Navigator.pushNamed(context, Routers.updateService);

  Future<void> goToAddCategory({
    required BuildContext context,
    CategoryModel? categoryModel,
  }) async {
    await Navigator.pushNamed(
      context,
      Routers.addCategory,
      arguments: categoryModel,
    );
    await init();
  }

  void setIcon(int index) {
    listCategory[index].isIconCategory = !listCategory[index].isIconCategory;
    notifyListeners();
  }

  void setIconFloating() {
    isIconFloatingButton = !isIconFloatingButton;
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

  dynamic showWaningDiaglog({String? title, Function()? onTapRight}) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: title ?? '',
          leftButtonName: SignUpLanguage.cancel,
          onTapLeft: () {
            Navigator.pop(context);
          },
          rightButtonName: CategoryLanguage.confirm,
          onTapRight: () async {
            await onTapRight!();
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

  dynamic showSuccessDiaglog(_) async {
    await showDialog(
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
    await pullRefresh();
  }

  void closeDialog(BuildContext context) {
    timer = Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> getCategory(
    int page,
    bool? isNewList, {String? search}
  ) async {
    final result = await categoryApi.getListCategory(CategoryParams(
      page: page,
      isUser: 1,
      search: search??''
    ),);

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading = true;
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      if (isNewList!) {
        newListCategory = value as List<CategoryModel>;
      } else {
        listCategory = value as List<CategoryModel>;
      }
    }
    notifyListeners();
  }

  // Future<void> getListSearch(String? search) async {
  //   final result = await categoryApi.getListCategory(
  //     page,'',
  //   );

  //   final value = switch (result) {
  //     Success(value: final listMyCustomer) => listMyCustomer,
  //     Failure(exception: final exception) => exception,
  //   };

  //   if (!AppValid.isNetWork(value)) {
  //     isLoading = true;
  //   } else if (value is Exception) {
  //     isLoading = true;
  //   } else {
  //     isLoading = false;
  //     listCategory = value as List<CategoryModel>;
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> deleteCategory(int id) async {
  //   LoadingDialog.showLoadingDialog(context);
  //   final result = await categoryApi.deleteCategory(id);
  //   final value = switch (result) {
  //     Success(value: final isTrue) => isTrue,
  //     Failure(exception: final exception) => exception,
  //   };
  //   if (!AppValid.isNetWork(value)) {
  //     LoadingDialog.hideLoadingDialog(context);
  //     showDialogNetwork(context);
  //   } else if (value is Exception) {
  //     LoadingDialog.hideLoadingDialog(context);
  //     showErrorDialog(context);
  //   } else {
  //     LoadingDialog.hideLoadingDialog(context);
  //     showSuccessDiaglog(context);
  //   }
  //   notifyListeners();
  // }

  Future<void> putCategory(int id) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await categoryApi.putCategory(
      CategoryParams(name: 'null', id: id),
    );

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
      showSuccessDiaglog(context);
      await pullRefresh();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
