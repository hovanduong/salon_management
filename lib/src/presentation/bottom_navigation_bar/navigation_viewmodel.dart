import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import '../home_detail/home_detail.dart';
import 'components/icon_tabs.dart';

class NavigateViewModel extends BaseViewModel {
  int selectedIndex = 0;
  dynamic init() {}

  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
