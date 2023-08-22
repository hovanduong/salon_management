import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../base/base.dart';
import '../home_detail/home_detail.dart';

class NavigateViewModel extends BaseViewModel {
  int currentIndex = 0;

  dynamic init() {}

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (currentIndex == index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeDetailScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeDetailScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeDetailScreen()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeDetailScreen()),
              );
              break;
          }
        }
        currentIndex = index;
        notifyListeners();
      },
      selectedItemColor: AppColors.FIELD_GREEN,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle,
            size: 40,
            color: AppColors.FIELD_GREEN,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Wallet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
    );
  }
}
