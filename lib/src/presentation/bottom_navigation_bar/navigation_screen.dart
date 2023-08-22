import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';

import '../statistics/statistics.dart';
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.FIELD_GREEN,
        elevation: 0,
        child: Container(
          child: Icon(Icons.add),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(98, 248, 247, 247),
                spreadRadius: 20,
                blurRadius: 20,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _viewModel!.appBarNavigator(),
    );
  }

}
