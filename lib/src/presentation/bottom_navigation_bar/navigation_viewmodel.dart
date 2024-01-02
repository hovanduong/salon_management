import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../configs/ad_mode_service/ad_mode_service.dart';
import '../../configs/configs.dart';
import '../../configs/language/navigate_language.dart';
import '../../resource/service/income_api.dart';
import '../base/base.dart';

class NavigateViewModel extends BaseViewModel {
  int selectedIndex = 0;
  BannerAd? bannerAd;
  dynamic init(IncomeParams? params) {
    if (params != null) {
      selectedIndex = params.page ?? 0;
    }
    notifyListeners();
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
        ) ??
        false;
  }
}
