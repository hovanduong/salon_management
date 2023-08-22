import 'package:flutter/material.dart';

import '../base/base.dart';

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
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      // body: Navigator(
      //   onGenerateRoute: (settings) {
      //     return
      //     MaterialPageRoute(
      //       builder: (context) => _viewModel!.screens[_viewModel!.index],
      //       settings: settings,
      //     );
      //   },
      // ),
      // body: _viewModel!.screens[_viewModel!.currentIndex],
      bottomNavigationBar: _viewModel!.bottomNavigationBar(),
    );
  }
}
