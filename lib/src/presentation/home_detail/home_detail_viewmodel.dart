import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/service.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class HomeDetailViewModel extends BaseViewModel{
  final pageController = PageController(initialPage: 0);
  double currentPageValue = 0;
  AuthApi authApi= AuthApi();
  Service? serviceDetails;

  Future<void> init(String? id)async{
    if(id!=null){
      await getServiceDetails(id);
    }
    initPage();
  }

  void initPage(){
    pageController.addListener(() {
      currentPageValue = pageController.page!;
      notifyListeners();
    });
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
          onTap: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }


  Future<void> getServiceDetails(String id) async {
    final result = await authApi.detailsService(
      id: id,
    );

    final value = switch (result) {
      Success(value: final serviceDetails) => serviceDetails,
      Failure(exception: final exception) => exception,
    };
    
    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      // showOpenDialog(context);
    } else {
      serviceDetails= value as Service?;
    }
    notifyListeners();
  }

  List listImageGirl= [
    'https://haycafe.vn/wp-content/uploads/2022/02/Anh-gai-xinh-Viet-Nam.jpg',
    'https://hinhnen4k.com/wp-content/uploads/2023/02/anh-gai-xinh-2k4-1.png',
    'https://www.ldg.com.vn/media/uploads/uploads/21205817-hinh-anh-gai-xinh-11.jpg',
    'https://taimienphi.vn/tmp/cf/aut/anh-gai-xinh-1.jpg',
    'https://adoreyou.vn/wp-content/uploads/cute-hot-girl-700x961.jpg'
  ];
}