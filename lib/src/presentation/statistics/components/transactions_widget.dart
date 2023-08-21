import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../../configs/configs.dart';
import '../statistics.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key, required this.data});
  final List<ChartData> data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
                color:
                    Colors.transparent, // Thay đổi màu thành Colors.transparent
              ),
              axisLine: const AxisLine(color: Colors.transparent),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(
                color:
                    Colors.transparent, // Thay đổi màu thành Colors.transparent
              ),
              axisLine: const AxisLine(color: Colors.transparent),
            ),
            series: <ChartSeries>[
              SplineSeries<ChartData, String>(
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
          )),
    );
  }
}
