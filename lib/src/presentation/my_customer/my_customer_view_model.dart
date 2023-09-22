import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/category_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';
import '../../resource/service/my_customer_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class MyCustomerViewModel extends BaseViewModel{
  MyCustomerApi myCustomerApi = MyCustomerApi();
  List<MyCustomerModel> listMyCustomer=[];
  bool isLoading = true;
  bool loadingMore = false;
 
  ScrollController scrollController = ScrollController();

  Future<void> init() async {
    scrollController.addListener(scrollListener);
    isLoading = true;
    await getCategory();
    notifyListeners();
  }

  dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      loadingMore = true;
      Future.delayed(const Duration(seconds: 2), () {
        // loadMoreData();
        loadingMore = false;
      });
 
      notifyListeners();
    }
  }

  Future<void> pullRefresh() async {
    await init();
    notifyListeners();
  }

  Future<void> goToAddMyCustomer(BuildContext context)
    => Navigator.pushNamed(context, Routers.myCustomerAdd);

  Future<void> goToMyCustomerEdit(BuildContext context, MyCustomerModel myCustomerModel)
    => Navigator.pushNamed(context, Routers.myCustomerEdit, arguments: myCustomerModel);


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

  dynamic showWaningDiaglog(int id){
    showDialog(
      context: context,
      builder: (context) {
        closeDialog(context);
        return WarningDialog(
          image: AppImages.icPlus,
          title: '${CategoryLanguage.areYouSure}!',
          leftButtonName: SignUpLanguage.cancel,
          onTapLeft: () {
            Navigator.pop(context);
          },
          rightButtonName: CategoryLanguage.yes,
          onTapRight: (){
            // deleteCategory(id);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  dynamic showErrorDialog(_){
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

  dynamic showSuccessDiaglog(_){
    showDialog(
      context: context,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
        );
      },
    );
  }

  void closeDialog(BuildContext context){
    Timer(const Duration(seconds: 2), () => Navigator.pop(context),);
  }

  Future<void> getCategory() async {
    final result = await myCustomerApi.getMyCustomer();

    final value = switch (result) {
      Success(value: final listMyCustomer) => listMyCustomer,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDialog(context);
    } else {
      isLoading = false;
      listMyCustomer = value as List<MyCustomerModel>;
    }
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
      showSuccessDiaglog(context);
      await getCategory();
    }
    notifyListeners();
  }
}