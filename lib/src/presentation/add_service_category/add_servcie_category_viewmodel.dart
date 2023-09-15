import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/model/my_category_model.dart';
import '../../resource/model/my_service_model.dart';
import '../../resource/model/radio_model.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class AddServiceCategoriesViewModel extends BaseViewModel{
  TextEditingController nameServiceController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  List<CategoryModel> listCategory = <CategoryModel>[];
  Map<int, String> mapCategory ={};
  bool enableSubmit = false;
  String messageErorrNameService='';
  String messageErorrPrice='';
  AuthApi serviceApi= AuthApi();
  List<RadioModel> selectedCategory=[];
  List<bool> listIsCheck=[];
  AuthApi authApi = AuthApi();
  List<int> categoryId=[];
  bool isColorProvinces = false;

  Future<void> init() async{
    await getCategory();
    await initMapCategory();
  }

  Future<void> changeValueCategory(List<RadioModel> value) async {
    selectedCategory.clear();
    selectedCategory =value;
    // await clearDatAgencies();
    notifyListeners();
  }

  // Future<void> setCategory() async{
  //   if(selectedCategory.isNotEmpty){
  //     selectedCategory.forEach((element) { 
  //       listCategory.forEach((element) {
  //         mapCategory.addAll({element.id!: '${element.name}'},);
  //       });
  //     });
  //   }
  //   notifyListeners();
  // }

  Future<void> setCategoryId() async{
    categoryId.clear();
    if(selectedCategory.isNotEmpty){
      selectedCategory.forEach((element) { 
        categoryId.add(element.id!);
      });
    }
    notifyListeners();
  }

  Future<void> initMapCategory() async{
    listCategory.forEach((element) {
      mapCategory.addAll({element.id!: '${element.name}'},);
    });
    print(mapCategory);
    notifyListeners();
  }

  void removeCategory(int index){
    selectedCategory.removeAt(index);
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
      && priceController.text!='' && messageErorrPrice == ''
      && selectedCategory.isNotEmpty) {
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

  dynamic showErrorDialog(_){
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

  dynamic showSuccessDiglot(_){
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

  Future<void> getCategory() async {
    listCategory.clear();
    final result = await authApi.getCategory();

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
    }
    notifyListeners();
  }

  Future<void> postService() async {
    final result = await authApi.postService(
      AuthParams(
        myServiceModel: MyServiceModel(
          name: nameServiceController.text,
          money: priceController.text,
        ),
        listCategory: categoryId,
      ),
    );

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDialog(context);
    } else {
      showSuccessDiglot(context);
    }
    notifyListeners();
  }
}