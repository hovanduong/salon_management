import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../configs/language/statistics_language.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({
    super.key,
    this.available,
    this.spend,
    this.earning,
    this.touchCallback,
    this.showingSections,
  });

  final List<PieChartSectionData>? showingSections;
  final Function(FlTouchEvent, PieTouchResponse?)? touchCallback;
  final String? earning;
  final String? spend;
  final String? available;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SpaceBox.sizeSmall, vertical: SpaceBox.sizeLarge),
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
                        touchCallback!(event, pieTouchResponse);
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 20,
                    sections: showingSections,
                  ),
                ),
              ),
            ),
            const Paragraph(content: "248.57", style: STYLE_LARGE_BOLD),
            const SizedBox(
              height: 5,
            ),
            Paragraph(content: StatisticsLanguage.availableBalance),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Paragraph(
                  content: StatisticsLanguage.earning,
                ),
                Paragraph(
                  content: StatisticsLanguage.spend,
                ),
                Paragraph(
                  content: StatisticsLanguage.available,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Paragraph(
                  content: earning ?? '',
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.PRIMARY_RED,
                  ),
                ),
                Paragraph(
                  content: spend ?? '',
                  style: STYLE_MEDIUM.copyWith(color: AppColors.COLOR_GREY),
                ),
                Paragraph(
                  content: available ?? '',
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
}
