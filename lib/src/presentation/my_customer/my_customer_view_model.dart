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

class MyCustomerViewModel extends BaseViewModel{
  MyCustomerApi myCustomerApi = MyCustomerApi();
  ScrollController scrollController = ScrollController();

  List<MyCustomerModel> listMyCustomer=[];
  List<MyCustomerModel> listCurrent=[];
  List<MyCustomerModel> listSearch=[];
  List<MyCustomerModel> foundCustomer=[];

  bool isLoading = true;
  bool loadingMore = false;

  int page=1;

  Future<void> init() async {
    page=1;
    isLoading = true;
    await getMyCustomer(page);
    scrollController.addListener(scrollListener);
    listCurrent=listMyCustomer;
    foundCustomer=listMyCustomer;
    notifyListeners();
  }

  Future<void> filterCategory(String searchCategory) async {
    await getListSearch(searchCategory);
    var listSearchCategory = <MyCustomerModel>[];
    listSearchCategory = listSearch.where(
      (element) => element.phoneNumber!.toLowerCase().contains(searchCategory) 
      || element.fullName!.toLowerCase().contains(searchCategory),)
    .toList();
    foundCustomer=listSearchCategory;
    notifyListeners();
  }

  Future<void> onSearchCategory(String value) async{
    if(value.isEmpty){
      foundCustomer = listCurrent;  
    }else{
      final searchCategory = value.toLowerCase();
      await filterCategory(searchCategory);
    }
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    page+=1;
    await getMyCustomer(page);
    listCurrent = [...listCurrent, ...listMyCustomer];
    foundCustomer=listCurrent;
    loadingMore = false;
    notifyListeners();
  }

  dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      loadingMore = true;
      Future.delayed(const Duration(seconds: 2), loadMoreData);
 
      notifyListeners();
    }
  }

  Future<void> pullRefresh() async {
    await init();
    notifyListeners();
  }

  Future<void> goToAddMyCustomer(BuildContext context)
    => Navigator.pushNamed(context, Routers.myCustomerAdd);

  Future<void> goToMyCustomerEdit(
    BuildContext context, MyCustomerModel myCustomerModel,)
      => Navigator.pushNamed(
        context, Routers.myCustomerEdit, arguments: myCustomerModel,);


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

  dynamic showWaningDiaglog(int id){
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
          rightButtonName: CategoryLanguage.yes,
          onTapRight: (){
            deleteMyCustomer(id);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  dynamic showErrorDialog(_){
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

  dynamic showSuccessDiaglog(_){
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

  void closeDialog(BuildContext context){
    Timer(const Duration(seconds: 1), () => Navigator.pop(context),);
  }

  Future<void> getMyCustomer(int page) async {
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
      listMyCustomer = value as List<MyCustomerModel>;
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

  Future<void> getListSearch(String search) async {
    final result = await myCustomerApi.getListSearch(search);

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
      listSearch = value as List<MyCustomerModel>;
    }
    isLoading = false;
    notifyListeners();
  }
}
