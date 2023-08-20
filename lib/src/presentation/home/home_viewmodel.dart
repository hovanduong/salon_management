import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/service_model.dart';
import '../../utils/app_valid.dart';
import '../app_routers.dart';
import '../base/base.dart';
import '../routers.dart';

class Constants {
  static const homeScreen = 'HomeScreen';
}

class HomeViewModel extends BaseViewModel {
  final pageController = PageController(initialPage: 0);
  double currentPageValue = 0;
  AuthApi authApi = AuthApi();
  List<Service> listService = [];

  Future<void> init() async {
    initPage();
    await getService();
  }

  List listImageGirl = [
    'https://haycafe.vn/wp-content/uploads/2022/02/Anh-gai-xinh-Viet-Nam.jpg',
    'https://hinhnen4k.com/wp-content/uploads/2023/02/anh-gai-xinh-2k4-1.png',
    'https://www.ldg.com.vn/media/uploads/uploads/21205817-hinh-anh-gai-xinh-11.jpg',
    'https://taimienphi.vn/tmp/cf/aut/anh-gai-xinh-1.jpg',
    'https://adoreyou.vn/wp-content/uploads/cute-hot-girl-700x961.jpg'
  ];

  void setHomeScreen() {
    ConfigAnalytics.setCurrentScreen(Constants.homeScreen);
  }

  void initPage() {
    pageController.addListener(() {
      currentPageValue = pageController.page!;
      notifyListeners();
    });
  }

  Future<void> goToHomeDetails(int index) async {
    // Navigator.pushNamed(
    //       context,
    //       Routers.homeDetails,
    //       arguments: listService[index].id,
    //     );
    final id = listService[index].id;
    if (id != null) {
      await AppRouter.goToHomeDetails(context, listService[index].id!);
    } else {
      // show loi
    }
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

  dynamic showThreeloading(_) {
    showDialog(
      context: context,
      builder: (context) {
        return ThreeBounceLoading(
          duration: const Duration(seconds: 3),
          itemBuilder: (context, index) => const Paragraph(),
          // content: CreatePasswordLanguage.errorNetwork,
          // image: AppImages.icPlus,
          // title: SignUpLanguage.failed,
          // buttonName: SignUpLanguage.cancel,
          // color: AppColors.BLACK_500,
          // colorNameLeft: AppColors.BLACK_500,
          // onTap: () {
          //   Navigator.pop(context);
          // },
        );
      },
    );
  }

  Future<void> getService() async {
    final result = await authApi.getService();

    final value = switch (result) {
      Success(value: final service) => service,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      // showOpenDialog(context);
    } else {
      listService = value as List<Service>;
    }
    notifyListeners();
  }
}
