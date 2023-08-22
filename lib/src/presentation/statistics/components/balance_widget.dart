import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../configs/configs.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({
    super.key,
    required this.available,
    required this.spend,
    required this.earning,
    required this.touchCallback,
    required this.showingSections,
  });

  final showingSections;
  final touchCallback;
  final earning;
  final spend;
  final available;
  @override
  Widget build(BuildContext context) {
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
                        touchCallback;
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
                  content: earning,
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.PRIMARY_RED,
                  ),
                ),
                Paragraph(
                  content: spend,
                  style: STYLE_MEDIUM.copyWith(color: AppColors.COLOR_GREY),
                ),
                Paragraph(
                  content: available,
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
