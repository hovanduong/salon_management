import 'package:flutter/material.dart';

import '../base/base.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../configs/configs.dart';

class StatisticsViewModel extends BaseViewModel {
  List<ChartData> data = [];
  int touchedIndex = -1;
  dynamic init() {
    fetchData();
  }

  void fetchData() {
    data = [
      ChartData('20', 3500),
      ChartData('21', 1600),
      ChartData('22', 2500),
      ChartData('23', 3000),
      ChartData('24', 2930),
      ChartData('25', 4000),
      ChartData('26', 1000),
    ];
    notifyListeners();
  }

  List<PieChartSectionData> showingSections() {
    final sectionValues = <double>[253.6, 587.4, 729.7]; // Giá trị của các phần
    final totalValue =
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
            color: AppColors.PRIMARY_RED,
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
        case 2:
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
        default:
          throw 'Invalid index';
      }
    });
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
