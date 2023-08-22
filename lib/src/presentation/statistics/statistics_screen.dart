import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../base/base.dart';
import 'package:fl_chart/fl_chart.dart';

import 'components/balance_widget.dart';
import 'components/header_widget.dart';
import 'components/navigationbar.dart';
import 'components/transactions_widget.dart';
import 'statistics.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  StatisticsViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<StatisticsViewModel>(
      viewModel: StatisticsViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) {
        return buildStatisticsScreen();
      },
    );
  }

  Widget buildStatisticsScreen() {
    return SafeArea(
      top: true,
      right: false,
      left: false,
      bottom: false,
      child: Scaffold(
        body: Column(
          children: [
            buildHeaderWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildBalanceWidget(),
                    buildTransactionsWidget(), 
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: buildBar(), // xóa
      ),
    );
  }

  Widget buildBalanceWidget() {
    return BalanceWidget(
      available: _viewModel!.showingSections()[0].value.toString(),
      spend: _viewModel!.showingSections()[1].value.toString(),
      earning: _viewModel!.showingSections()[2].value.toString(),
      touchCallback: (event, pieTouchResponse) {
        _viewModel!.handleTouchCallback(event, pieTouchResponse);
      },
      showingSections: _viewModel!.showingSections(),
    );
  }

  Widget buildBar() {
    return Navigationbarrrr(
      currentIndex: _viewModel!.currentIndex,
      onTap: (index) {},
    );
  }

  Widget buildHeaderWidget() {
    return const Padding(
      padding: EdgeInsets.only(top: 30),
      child: HeaderWidget(),
    );
  }

  Widget buildTransactionsWidget() {
    return Transactions(data: _viewModel!.data);
  }
}
