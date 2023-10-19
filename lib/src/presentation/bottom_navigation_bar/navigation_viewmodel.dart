import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/configs.dart';
import '../../configs/language/navigate_language.dart';
import '../base/base.dart';

class NavigateViewModel extends BaseViewModel {
  int selectedIndex = 0;
  dynamic init(int? page) {
    if(page != null){
      selectedIndex=page;
    }
  }

  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: NavigateLanguage.exitApp,
          content: NavigateLanguage.exitAppContent,
          leftButtonName: SignUpLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: BookingLanguage.confirm,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
        );
      },
    )??false;
  }
}
