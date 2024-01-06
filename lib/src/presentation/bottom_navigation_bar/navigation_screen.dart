// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../configs/ad_mode_service/ad_mode_service.dart';
import '../../configs/configs.dart';
import '../../configs/language/navigate_language.dart';
import '../../resource/service/income_api.dart';
import '../base/base.dart';

import '../booking_history/booking_history.dart';
import '../calendar/calendar.dart';
import '../debit/debit_screen.dart';
import '../home/home.dart';
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
  bool isShowBanner = false;
  @override
  Widget build(BuildContext context) {
    final page = ModalRoute.of(context)?.settings.arguments;
    return BaseWidget<NavigateViewModel>(
      viewModel: NavigateViewModel(),
      // onViewModelReady: (viewModel) {
      //   _viewModel = viewModel;
      //   _viewModel!.init(page as IncomeParams?);
      // },
      onViewModelReady: (viewModel) =>
          _viewModel = viewModel!..init(page as IncomeParams?),
      builder: (context, viewModel, child) => buildNavigateScreen(),
    );
  }

  Widget buildNavigateScreen() {
    return WillPopScope(
      onWillPop: () => _viewModel!.showExitPopup(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: _viewModel!.selectedIndex,
          children: [
            if (_viewModel!.selectedIndex == 0)
              const HomeScreen()
            else
              Container(),
            if (_viewModel!.selectedIndex == 1)
              const CalendarScreen()
            else
              Container(),
            if (_viewModel!.selectedIndex == 2)
              const BookingHistoryScreen()
            else
              Container(),
            if (_viewModel!.selectedIndex == 3)
              const DebitScreen()
            else
              Container(),
            if (_viewModel!.selectedIndex == 4)
              const ProfileScreen()
            else
              Container(),
            if (_viewModel!.selectedIndex == 5)
              const SizedBox()
            else
              Container(),
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            appBarNavigator(),
            if (_viewModel!.isShowBanner)
              const SizedBox(
                height: 135,
              ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AdBanner(
                  onBanner: (value) {
                    Future.delayed(Duration.zero, () {
                      _viewModel!.onChangeBanner(value: value);
                    });
                  },
                )),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar appBarNavigator() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _viewModel!.selectedIndex,
      selectedItemColor: AppColors.PRIMARY_PINK,
      unselectedItemColor: AppColors.BLACK_400,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
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
          label: NavigateLanguage.home,
        ),
        BottomNavigationBarItem(
          icon: IconTabWidget(
            name: _viewModel!.selectedIndex == 1
                ? AppImages.icInvoice
                : AppImages.icWalletLine,
          ),
          label: NavigateLanguage.report,
        ),
        BottomNavigationBarItem(
          icon: IconTabWidget(
            name: _viewModel!.selectedIndex == 2
                ? AppImages.icStatist
                : AppImages.icStatistLine,
          ),
          label: NavigateLanguage.appointmentSchedule,
        ),
        BottomNavigationBarItem(
          icon: IconTabWidget(
            color: _viewModel!.selectedIndex == 3
                ? AppColors.PRIMARY_GREEN
                : AppColors.BLACK_300,
            name: _viewModel!.selectedIndex == 3
                ? AppImages.icDebit
                : AppImages.icDebit,
          ),
          label: NavigateLanguage.debitBook,
        ),
        BottomNavigationBarItem(
          icon: IconTabWidget(
            name: _viewModel!.selectedIndex == 4
                ? AppImages.icProfile
                : AppImages.icProfileLine,
          ),
          label: NavigateLanguage.account,
        ),
      ],
    );
  }
}
