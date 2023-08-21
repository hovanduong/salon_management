import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../base/base.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'components/header_widget.dart';
import 'components/transactions_widget.dart';
import 'statistics.dart';

class StaticticsScreen extends StatefulWidget {
  const StaticticsScreen({super.key});

  @override
  State<StaticticsScreen> createState() => _StaticticsScreenState();
}

class _StaticticsScreenState extends State<StaticticsScreen> {
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
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(children: [
          buildHeaderWidget(),
          buildBalance(),
          buildTransactionsWidget(),
        ]),
      ),
    ));
  }

  Widget buildBalance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _viewModel!.touchedIndex = -1;
                            return;
                          }
                          _viewModel!.touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 20,
                    sections: _viewModel!.showingSections(),
                  ),
                ),
              ),
            ),
            const Paragraph(content: "248.57", style: STYLE_LARGE_BOLD),
            const SizedBox(
              height: 5,
            ),
            const Paragraph(content: 'Available Balance'),
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Earning'),
                Text('Spend'),
                Text('Available'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Paragraph(
                  content: _viewModel!.showingSections()[0].value.toString(),
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.PRIMARY_RED,
                  ),
                ),
                Paragraph(
                  content: _viewModel!.showingSections()[1].value.toString(),
                  style: STYLE_MEDIUM.copyWith(color: AppColors.COLOR_GREY),
                ),
                Paragraph(
                  content: _viewModel!.showingSections()[2].value.toString(),
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.FIELD_GREEN,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderWidget() {
    return const HeaderrWidget();
  }

  Widget buildTransactionsWidget() {
    return Transactions(data: _viewModel!.data);
  }
}
