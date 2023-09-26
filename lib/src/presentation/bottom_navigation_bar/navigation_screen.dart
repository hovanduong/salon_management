import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';

import '../booking/booking.dart';
import '../booking_history/booking_history.dart';
import '../homepage/homepage_screen.dart';
import '../profile/profile_screen.dart';
import 'components/icon_tabs.dart';
import 'navigation.dart';

class NavigateScreen extends StatefulWidget {
  const NavigateScreen({super.key});

  @override
  State<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends State<NavigateScreen> {
  final PageStorageBucket bucket = PageStorageBucket();
  NavigateViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<NavigateViewModel>(
      viewModel: NavigateViewModel(),
      onViewModelReady: (viewModel) {
        _viewModel = viewModel;
        _viewModel!.init();
      },
      builder: (context, viewModel, child) => buildNavigateScreen(),
    );
  }

  Widget buildNavigateScreen() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _viewModel!.selectedIndex,
        children: [
          if (_viewModel!.selectedIndex == 0)
            const HomePageScreen(
              key: PageStorageKey('HomePage'),
            )
          else
            Container(),
          if (_viewModel!.selectedIndex == 1)
            const BookingHistoryScreen(
              key: PageStorageKey('BookingPage'),
            )
          else
            Container(),
          if (_viewModel!.selectedIndex == 2)
            const BookingHistoryScreen(
              key: PageStorageKey('HistoryPage'),
            )
          else
            Container(),
          if (_viewModel!.selectedIndex == 3)
            const ProfileScreen(
              key: PageStorageKey('ProfilePage'),
            )
          else
            Container(),
          if (_viewModel!.selectedIndex == 4) const SizedBox() else Container(),
        ],
      ),
      bottomNavigationBar: appBarNavigator(),
    );
  }

  BottomNavigationBar appBarNavigator() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _viewModel!.selectedIndex,
      selectedItemColor: AppColors.PRIMARY_PINK,
      unselectedItemColor: AppColors.BLACK_400,
      onTap: (index) {
        _viewModel!.changeIndex(index);
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: IconTabWidget(
            name: _viewModel!.selectedIndex == 0
                ? AppImages.icHome
                : AppImages.icHomeLine,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconTabWidget(
            name: _viewModel!.selectedIndex == 1
                ? AppImages.icStatist
                : AppImages.icStatistLine,
          ),
          label: 'Lich hẹn',
        ),
        BottomNavigationBarItem(
          icon: IconTabWidget(
            name: _viewModel!.selectedIndex == 2
                ? AppImages.icWallet
                : AppImages.icWalletLine,
          ),
          label: 'Hóa đơn',
        ),
        BottomNavigationBarItem(
          icon: IconTabWidget(
            name: _viewModel!.selectedIndex == 3
                ? AppImages.icProfile
                : AppImages.icProfileLine,
          ),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
