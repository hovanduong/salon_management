// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final page= ModalRoute.of(context)?.settings.arguments;
    return BaseWidget<NavigateViewModel>(
      viewModel: NavigateViewModel(),
      onViewModelReady: (viewModel) {
        _viewModel = viewModel;
        _viewModel!.init(page as IncomeParams?);
      },
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
              // const OverViewScreen(
              //   // key: PageStorageKey('HomePage'),
              // )
              const HomeScreen(
                // key: PageStorageKey('HomePage'),
              )
            else
              Container(),
            if (_viewModel!.selectedIndex == 1)
              const CalendarScreen(
                // key: PageStorageKey('invoicePage'),
              )
            else
              Container(),
            if (_viewModel!.selectedIndex == 2)
              const BookingHistoryScreen(
                // key: PageStorageKey('BookingPage'),
              )
            else
              Container(),
            if (_viewModel!.selectedIndex == 3)
              const DebitScreen(
                // key: PageStorageKey('BookingPage'),
              )
            else
              Container(),
            if (_viewModel!.selectedIndex == 4)
              const ProfileScreen(
                // key: PageStorageKey('ProfilePage'),
              )
            else
              Container(),
            if (_viewModel!.selectedIndex == 5) const SizedBox() else Container(),
          ],
        ),
        bottomNavigationBar: appBarNavigator(),
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
            color: _viewModel!.selectedIndex == 3?
              AppColors.PRIMARY_GREEN: AppColors.BLACK_300 ,
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
