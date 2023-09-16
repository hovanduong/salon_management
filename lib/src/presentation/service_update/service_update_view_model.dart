import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/model/my_category_model.dart';
import '../../resource/model/my_service_model.dart';
import '../../resource/model/radio_model.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/category_api.dart';
import '../../resource/service/my_service_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class ServiceUpdateViewModel extends BaseViewModel {
  TextEditingController nameServiceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<CategoryModel> listCategory = <CategoryModel>[];
  Map<int, String> mapCategory = {};
  bool enableSubmit = false;
  String messageErrorNameService = '';
  String messageErrorPrice = '';
  CategoryApi categoryApi = CategoryApi();
  List<RadioModel> selectedCategory = [];
  List<bool> listIsCheck = [];
  AuthApi authApi = AuthApi();
  List<int> categoryId = [];
  bool isColorProvinces = false;
  MyServiceApi myServiceApi = MyServiceApi();
  Future<void> init() async {
    await getCategory();
    await initMapCategory();
  }

  Future<void> changeValueCategory(List<RadioModel> value) async {
    selectedCategory.clear();
    selectedCategory = value;
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
    print(mapCategory);
    notifyListeners();
  }

  void removeCategory(int index) {
    selectedCategory.removeAt(index);
    notifyListeners();
  }

  void validNameService(String? value) {
    if (value == null || value.isEmpty) {
      messageErrorNameService = ServiceAddLanguage.emptyNameError;
    } else if (value.length < 2) {
      messageErrorNameService = ServiceAddLanguage.serviceNameMinLength;
    } else {
      messageErrorNameService = '';
    }
    notifyListeners();
  }

  void validPrice(String? value) {
    if (value == null || value.isEmpty) {
      messageErrorPrice = ServiceAddLanguage.emptyMoneyError;
    } else {
      messageErrorPrice = '';
    }
    notifyListeners();
  }

  void onSubmit() {
    if (messageErrorNameService == '' &&
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

  dynamic showErrorDialog(_) {
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

  dynamic showSuccessDialog(_) {
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
    }
    notifyListeners();
  }

  Future<void> postService() async {
    final result = await myServiceApi.postService(
      AuthParams(
        myServiceModel: MyServiceModel(
          name: nameServiceController.text,
          money: double.parse(priceController.text.trim()) ,
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
      nameServiceController.text='';
      priceController.text='';
      selectedCategory.clear();
      categoryId.clear();
      showSuccessDialog(context);
    }
    notifyListeners();
  }
}
