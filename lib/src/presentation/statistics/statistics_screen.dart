import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../base/base.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'components/header_widget.dart';
import 'components/transactions_text_widget.dart';
import 'components/transactions_widget.dart';
import 'statistics.dart';

class StaticticsScreen extends StatefulWidget {
  const StaticticsScreen({super.key});

  @override
  State<StaticticsScreen> createState() => _StaticticsScreenState();
}

class _StaticticsScreenState extends State<StaticticsScreen> {
  StatisticsViewModel? _viewModel;
  int touchedIndex = -1;

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
          const TransactionsTextWidget(),
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
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                    sections: showingSections(),
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
                Text(showingSections()[0].value.toString()),
                Text(showingSections()[1].value.toString()),
                Text(showingSections()[2].value.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final List<double> sectionValues = [
      253.6,
      587.4,
      729.7
    ]; // Giá trị của các phần
    final double totalValue =
        sectionValues.reduce((a, b) => a + b); // Tính tổng giá trị của các phần

    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final percentage =
          (sectionValues[i] / totalValue * 100).toStringAsFixed(0) + '%';
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.FIELD_GREEN,
            value: sectionValues[i],
            title: percentage,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.COLOR_WHITE,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.LIGHT_ORANGE,
            value: sectionValues[i],
            title: percentage,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.COLOR_WHITE,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.COLOR_GREY,
            value: sectionValues[i],
            title: percentage,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.COLOR_WHITE,
              shadows: shadows,
            ),
          );
        default:
          throw 'Invalid index';
      }
    });
  }

  Widget buildHeaderWidget() {
    return const HeaderrWidget();
  }

  Widget buildTransactionsWidget() {
    return Transactions(data: _viewModel!.data);
  }
}
