import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/statistics_language.dart';
import '../statistics.dart';

class Transactions extends StatelessWidget {
  const Transactions({required this.data, super.key});
  final List<ChartData> data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeSmall),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SpaceBox.sizeLarge),
              child: Paragraph(
                content: StatisticsLanguage.transactions,
                style: STYLE_LARGE_BIG,
              ),
            ),
          ),
          DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(BorderRadiusSize.sizeLarge),
              ),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  header: '',
                  canShowMarker: true,
                  format: 'point.y',
                ),
                borderColor: Colors.transparent,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(
                    color: Colors.transparent,
                  ),
                  axisLine: const AxisLine(color: Colors.transparent),
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(
                    color: Colors.transparent,
                  ),
                  axisLine: const AxisLine(color: Colors.transparent),
                ),
                series: <ChartSeries>[
                  SplineSeries<ChartData, String>(
                    color: AppColors.FIELD_GREEN,
                    dataSource: data,
                    xValueMapper: (data, _) => data.x,
                    yValueMapper: (data, _) => data.y,
                    // markerSettings: const MarkerSettings(
                    //   isVisible: true,
                    //   shape: DataMarkerType.circle,
                    //   borderWidth: 2,
                    //   borderColor: Colors.white,
                    //   color: Colors.blue,
                    // ),
                  ),
                ],
              ),),
        ],
      ),
    );
  }
}
