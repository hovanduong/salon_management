import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../base/base.dart';
import '../home/home.dart';
import '../service_list/service_list.dart';
import '../update_profile/update_profile.dart';

class NavigateViewModel extends BaseViewModel {
  int selectIndex = 0;
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();

  final screens = [
    const HomeScreen(),
    const ServiceListScreen(),
    const UpdateProfileSreen(),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  dynamic init() {}

  CupertinoTabScaffold bottomNavigationBar() {
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: false,
      tabBar: CupertinoTabBar(
        onTap: (index) {
          if (selectIndex == index) {
            switch (index) {
              case 0:
                firstTabNavKey.currentState?.popUntil((r) => r.isFirst);
                break;
              case 1:
                secondTabNavKey.currentState?.popUntil((r) => r.isFirst);
                break;
              case 2:
                thirdTabNavKey.currentState?.popUntil((r) => r.isFirst);
                break;
            }
          }
          selectIndex = index;
          notifyListeners();
        },
        backgroundColor: AppColors.PRIMARY_LIGHT_PINK,
        activeColor: AppColors.PRIMARY_PINK,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'Lịch hẹn',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              navigatorKey: firstTabNavKey,
              builder: (context) => HomeScreen(),
            );
          case 1:
            return CupertinoTabView(
              navigatorKey: secondTabNavKey,
              builder: (context) {
                return const CupertinoPageScaffold(child: ServiceListScreen());
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) {
                return const CupertinoPageScaffold(child: ServiceListScreen());
              },
            );
          case 3:
            return CupertinoTabView(
              builder: (context) {
                return const CupertinoPageScaffold(child: UpdateProfileSreen());
              },
            );
          default:
            return CupertinoTabView(
              builder: (context) {
                return const CupertinoPageScaffold(child: HomeScreen());
              },
            );
        }
      },
    );
  }
}