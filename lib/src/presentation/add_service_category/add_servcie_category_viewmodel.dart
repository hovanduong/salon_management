import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/model/category_model.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import 'component/build_categories.dart';

class AddServiceCategoriesViewModel extends BaseViewModel{
  TextEditingController nameServiceController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  List<CategoryModel> listCategory = <CategoryModel>[];
  bool enableSubmit = false;
  String messageErorrNameService='';
  String messageErorrPrice='';
  AuthApi serviceApi= AuthApi();
  List<String>? selectedCategory=[];
  List<bool>? isCheck=[];
  AuthApi authApi = AuthApi();

  Future<void> init()async{
  }

  List<String> list = <String>[
    'abc',
    'xyz',
    'đi cháy phố',
    'đi hẹn hò',
    'đi chơi xuyên đêm'
  ];

  void updateStatusIsCheck(int index){
    isCheck![index] = !isCheck![index]; 
    notifyListeners();
  }

  void removeCategory(int index){
    selectedCategory!.removeAt(index);
    notifyListeners();
  }

  void createListIsCheck(){
    isCheck?.clear();
    for(var i=0; i<list.length; i++){
      isCheck!.add(false);
    }
    notifyListeners();
  }

  void setListIsCheck(){
    selectedCategory?.clear();
    for(var i=0; i<isCheck!.length; i++){
      if(isCheck![i]==true){
        selectedCategory!.add(list[i]);
      }
    }
    notifyListeners();
  }

  void addService() {
    // setListIsCheck();
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => BuildListCategories(
        category: list, 
        selectedCategory: selectedCategory,
      )
    );
    notifyListeners();
  }

  void validNameService(String? value) {
    if (value == null || value.isEmpty) {
      messageErorrNameService= ServiceAddLanguage.emptyNameError;
    }else if(value.length<6){
      messageErorrNameService=ServiceAddLanguage.serviceNameMinLenght;
    }else{
      messageErorrNameService='';
    }
    notifyListeners();
  }

  void validPrice(String? value) {
    if (value == null || value.isEmpty) {
      messageErorrPrice= ServiceAddLanguage.emptyMoneyError;
    }else{
      messageErorrPrice='';
    }
    notifyListeners();
  }

  void onSubmit() {
    if (messageErorrNameService == '' && nameServiceController.text!='' 
      && priceController.text!='' && messageErorrPrice == '') {
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
    }
    notifyListeners();
  }
}