import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';

import '../homepage/homepage_screen.dart';
import '../profile/profile_screen.dart';
import '../service_add/add_service.dart';
import 'components/icon_tabs.dart';
import 'navigation.dart';

class NavigateScreen extends StatefulWidget {
  const NavigateScreen({super.key});

  @override
  State<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends State<NavigateScreen> {
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.FIELD_GREEN,
          elevation: 10,
          child: const Icon(
            Icons.add,
            size: 35,
          ),
        ),
      ),
      body: IndexedStack(
        index: _viewModel!.selectedIndex,
        children: [
          if (_viewModel!.selectedIndex == 0)
            const HomePageScreen()
          else
            Container(),
          if (_viewModel!.selectedIndex == 1)
            const ServiceAddScreen()
          else
            Container(),
          if (_viewModel!.selectedIndex == 2) const SizedBox() else Container(),
          if (_viewModel!.selectedIndex == 3)
            const ProfileScreen()
          else
            Container(),
          if (_viewModel!.selectedIndex == 4) const SizedBox() else Container(),
        ],
      ),
      bottomNavigationBar: appBarNavigator(),
    );
  }

  BottomAppBar appBarNavigator() {
    return BottomAppBar(
      // color: const Color.fromARGB(255, 240, 241, 241),
      height: 60,
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeSmall),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: IconTabWidget(
                onTap: () => _viewModel!.changeIndex(0),
                name: _viewModel!.selectedIndex == 0
                    ? AppImages.icHome
                    : AppImages.icHomeLine,
              ),
            ),
            Expanded(
              flex: 1,
              child: IconTabWidget(
                onTap: () => _viewModel!.changeIndex(1),
                size: 25,
                name: _viewModel!.selectedIndex == 1
                    ? AppImages.icStatist
                    : AppImages.icStatistLine,
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 1,
              child: IconTabWidget(
                onTap: () => _viewModel!.changeIndex(2),
                name: _viewModel!.selectedIndex == 2
                    ? AppImages.icWallet
                    : AppImages.icWalletLine,
              ),
            ),
            Expanded(
              flex: 1,
              child: IconTabWidget(
                onTap: () => _viewModel!.changeIndex(3),
                name: _viewModel!.selectedIndex == 3
                    ? AppImages.icProfile
                    : AppImages.icProfileLine,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
