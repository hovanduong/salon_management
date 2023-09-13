import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/model/category_model.dart';
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
  List<String>? selectedCategory=[];
  List<bool>? listIsCheck=[];
  AuthApi authApi = AuthApi();
  Map<int, String> mapProvinces = {};
  int? categoryId;
  bool isColorProvinces = false;

  Future<void> init() async{
    await getCategory();
    await initMapCategory();
    notifyListeners();
  }

  Future<void> changeValueProvinces(MapEntry<dynamic, dynamic> value) async {
    categoryId = value.key;
    print(value.key);
    selectedCategory!.add(value.value);
    // await clearDatAgencies();
    notifyListeners();
  }
  
  List<String> list = <String>[
    'abc',
    'xyz',
    'đi cháy phố',
    'đi hẹn hò',
    'đi chơi xuyên đêm'
  ];

  Future<void> initMapCategory() async{
    listCategory.forEach((element) {
      mapCategory.addAll({element.id!: '${element.name}'},);
    });
    notifyListeners();
  }

  void updateStatusIsCheck(int index){
    listIsCheck![index] = !listIsCheck![index]; 
    notifyListeners();
  }

  void removeCategory(int index){
    selectedCategory!.removeAt(index);
    notifyListeners();
  }

  void createListIsCheck(){
    listIsCheck?.clear();
    for(var i=0; i<listCategory.length; i++){
      listIsCheck!.add(false);
    }
    notifyListeners();
  }

  void setListIsCheck(){
    selectedCategory?.clear();
    for(var i=0; i<listIsCheck!.length; i++){
      if(listIsCheck![i]==true){
        selectedCategory!.add(list[i]);
      }
    }
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
      && selectedCategory!.isNotEmpty) {
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
      createListIsCheck();
    }
    notifyListeners();
  }
}