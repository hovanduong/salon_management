import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/model/my_category_model.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class CategoryViewModel extends BaseViewModel {
  AuthApi authApi= AuthApi();
  List<CategoryModel> listCategory=[];
  List<bool> listIconCategory= [];
  bool isIconFloatingButton= true;
  TextEditingController category = TextEditingController();
  Future<void> init() async{
    await getCategory();
    notifyListeners();
  }

  // Future<void> goToAddServiceCategory(BuildContext context)
  //   => AppRouter.goToAddServiceCategory(context);

  // Future<void> goToAddCategory(BuildContext context)
  //   => AppRouter.goToCategoryAdd(context);

  void setIcon(int index){
    listIconCategory[index] = !listIconCategory[index];
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
        return WarningDialog(
          image: AppImages.icPlus,
          title: 'Are you sure!',
          leftButtonName: SignUpLanguage.cancel,
          onTapLeft: () {
            Navigator.pop(context);
          },
          rightButtonName: 'Yes',
          onTapRight: (){
            deleteCategory(id);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  dynamic showErrorDiaglog(_){
    showDialog(
      context: context,
      builder: (context) {
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

  void setListIcon(){
    for(var i=0; i<listCategory.length; i++){
      listIconCategory.add(true);
    }
    notifyListeners();
  }

  Future<void> getCategory() async {
    final result = await authApi.getCategory();

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDiaglog(context);
    } else {
      listCategory = value as List<CategoryModel>;
      setListIcon();
    }
    notifyListeners();
  }

  Future<void> deleteCategory(int id) async {
    final result = await authApi.deleteCategory(id);

    final value = switch (result) {
      Success(value: final isTrue) => isTrue,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDiaglog(context);
    } else {
      showSuccessDiaglog(context);
    }
    notifyListeners();
  }

  Future<void> putCategory(String name, int id) async {
    final result = await authApi.putCategory(
      AuthParams(name: name, id: id));

    final value = switch (result) {
      Success(value: final isTrue) => isTrue,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDiaglog(context);
    } else {
      showSuccessDiaglog(context);
    }
    notifyListeners();
  }
}
