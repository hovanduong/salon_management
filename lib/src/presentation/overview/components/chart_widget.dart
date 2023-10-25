// import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/homepage_language.dart';
import '../../../resource/model/model.dart';
import '../../../utils/date_format_utils.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({
    required this.data, 
    super.key, 
    this.daysInterval,
  });
  final List<RevenueChartModel> data;
  final int? daysInterval;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: SpaceBox.sizeSmall),
          child: Paragraph(
            content: HomePageLanguage.revenue,
            style: STYLE_LARGE_BIG,
          ),
        ),
        Container(
          width: 400,
          height: 400,
          padding: EdgeInsets.only(
            top: SizeToPadding.sizeMedium,
            bottom: SizeToPadding.sizeMedium,
            right: SizeToPadding.sizeSmall,),
          decoration: BoxDecoration(
            color: AppColors.COLOR_WHITE,
            borderRadius: BorderRadius.circular(
              BorderRadiusSize.sizeVerySmall,),
            boxShadow: [
              BoxShadow(
                blurRadius: SpaceBox.sizeMedium,
                color: AppColors.BLACK_200,
              ),
            ],
          ),
          child: LineChart(
            curve: Curves.linear,
            LineChartData(
              minX: 0,
              maxX: data.length.toDouble(),
              minY: 0,
              maxY: data.isNotEmpty? data.map((e) => 
                e.dailyRevenue??0,).toList().reduce(max)
                :7,
              baselineX: 4,
              baselineY: 20,
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: AppColors.PRIMARY_GREEN, width: 2),
              ),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: AppColors.BLACK_200,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                   return const FlLine(
                    color: AppColors.BLACK_200,
                    strokeWidth: 1,
                  );
                },
                drawVerticalLine: true,
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: Duration(days: daysInterval ?? 15)
                      .inMilliseconds
                      .toDouble(),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final day = value.toInt() < data.length
                        ? AppDateUtils.parseDate(
                          AppDateUtils.formatDateLocal(
                            data[value.toInt()].date.toString(),
                          ).split(' ')[0],).day
                        : 0;
                      return SideTitleWidget(axisSide: meta.axisSide, 
                        child: Text(day!=0? day.toString(): ''),);
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  spots: data.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), 
                      e.value.dailyRevenue!,);
                  }).toList(),
                  barWidth: 2,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                      // AppColors.FIELD_GREEN_Second, AppColors.FIELD_GREEN_First,
                      AppColors.PRIMARY_GREEN, AppColors.COLOR_WHITE,
                    ],),
                  ),
                  preventCurveOverShooting: true,
                  color: AppColors.PRIMARY_GREEN,
                  dotData: const FlDotData(show: false,),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
