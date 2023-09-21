import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/category_language.dart';
import '../../resource/model/my_category_model.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/category_api.dart';
import '../../resource/service/my_service_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class CategoryViewModel extends BaseViewModel {
  CategoryApi categoryApi= CategoryApi();
  MyServiceApi myServiceApi = MyServiceApi();
  List<CategoryModel> listCategory=[];
  List<bool> listIconCategory= [];
  bool isIconFloatingButton= true;
  TextEditingController category = TextEditingController();
  bool isLoading = true;
  bool loadingMore = false;
  bool isLoadingList = true;
 
  ScrollController scrollController = ScrollController();

  Future<void> init() async {
    scrollController.addListener(scrollListener);
    await getCategory();
    isLoading = false;
    isLoadingList = false;
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
    isLoadingList = true;
    await init();
    notifyListeners();
  }

  Future<void> goToAddServiceCategory(BuildContext context)
    => Navigator.pushNamed(context, Routers.addService);

  Future<void> goToUpdateServiceCategory(BuildContext context)
    => Navigator.pushNamed(context, Routers.updateService);

  Future<void> goToAddCategory(
    {required BuildContext context, CategoryModel? categoryModel,})
    => Navigator.pushNamed(context, Routers.addCategory, arguments: categoryModel);

  void setIcon(int index){
    listIconCategory[index]=!listIconCategory[index];
    notifyListeners();
  }

  void setIconFloating(){
    isIconFloatingButton = !isIconFloatingButton;
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
            deleteCategory(id);
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

  void setListIcon(){
    listIconCategory.clear();
    for(var i=0; i<listCategory.length; i++){
      listIconCategory.add(true);
    }
    notifyListeners();
  }

  void closeDialog(BuildContext context){
    Timer(const Duration(seconds: 1), () => Navigator.pop(context),);
  }

  Future<void> getCategory() async {
    final result = await categoryApi.getCategory();

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDialog(context);
    } else {
      listCategory = value as List<CategoryModel>;
      setListIcon();
      print(listCategory.length);
    }
    notifyListeners();
  }

  Future<void> deleteCategory(int id) async {
    final result = await categoryApi.deleteCategory(id);

    final value = switch (result) {
      Success(value: final isTrue) => isTrue,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDialog(context);
      await getCategory();
    } else {
      showSuccessDiaglog(context);
      await getCategory();
    }
    notifyListeners();
  }

  Future<void> putCategory(String name, int id) async {
    final result = await categoryApi.putCategory(
      AuthParams(name: name, id: id),);

    final value = switch (result) {
      Success(value: final isTrue) => isTrue,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDialog(context);
    } else {
      showSuccessDiaglog(context);
      await getCategory();
    }
    notifyListeners();
  }

  Future<void> deleteService(int idCategory, int idService) async {
    final result = await myServiceApi.deleteService(idCategory, idService);

    final value = switch (result) {
      Success(value: final isTrue) => isTrue,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDialog(context);
    } else {
      showSuccessDiaglog(context);
      await getCategory();
    }
    notifyListeners();
  }
}
