import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import '../home_detail/home_detail.dart';

class NavigateViewModel extends BaseViewModel {
  int selectedIndex = 0;

  void onTabTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  dynamic init() {}

  BottomAppBar appBarNavigator() {
    return BottomAppBar(
      color: const Color.fromARGB(255, 240, 241, 241),
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Image.asset(
                AppImages.imageHome,
                color:
                    selectedIndex == 0 ? AppColors.FIELD_GREEN : Colors.black,
              ),
              iconSize: 30,
              onPressed: () => onTabTapped(0),
            ),
            IconButton(
              icon: Image.asset(
                AppImages.imageVector,
                color:
                    selectedIndex == 1 ? AppColors.FIELD_GREEN : Colors.black,
              ),
              onPressed: () => onTabTapped(1),
            ),
            IconButton(
              icon: Image.asset(
                AppImages.imageWallet,
                color:
                    selectedIndex == 2 ? AppColors.FIELD_GREEN : Colors.black,
              ),
              iconSize: 30,
              onPressed: () => onTabTapped(2),
            ),
            IconButton(
              icon: Image.asset(
                AppImages.imageUser,
                color:
                    selectedIndex == 3 ? AppColors.FIELD_GREEN : Colors.black,
              ),
              iconSize: 30,
              onPressed: () => onTabTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}
