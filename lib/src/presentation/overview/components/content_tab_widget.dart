import 'package:flutter/material.dart';

import '../../../configs/constants/app_space.dart';
import '../../../configs/language/homepage_language.dart';
import '../../../resource/model/model.dart';
import 'components.dart';

class ContentTabWidget extends StatelessWidget {
  const ContentTabWidget({
    super.key, 
    this.dataChart,
    this.showRevenue=false,
    this.showTopService=false,
    this.showTopServicePackage=false, 
    this.onShowTopRevenue, 
    this.onShowTopService, 
    this.onShowTopServicePackage,
  });

  final List<RevenueChartModel>? dataChart;
  final bool showRevenue;
  final bool showTopService;
  final bool showTopServicePackage;
  final Function()? onShowTopRevenue;
  final Function()? onShowTopService;
  final Function()? onShowTopServicePackage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const BuildDateWidget(date: '01/10/2023 - 31/10/023'),
          const FieldRevenueWidget(),
          // ChartWidget(data: dataChart ?? []),
          SizedBox(height: SpaceBox.sizeMedium,),
          // TopWidget(
          //   title: HomePageLanguage.totalRevenueExpenditure,
          //   widget: Paragraph(content: '0 đ',
          //     style: STYLE_MEDIUM.copyWith(color: AppColors.COLOR_GREY_BLUE),
          //   ),
          // ),
          TopWidget(title: HomePageLanguage.revenue,
            isShowTop: showRevenue,
            onTap: () => onShowTopRevenue!(),),
          TopWidget(title: HomePageLanguage.topService,
            isShowTop: showTopService,
            onTap: () => onShowTopService!(),),
          TopWidget(title: HomePageLanguage.topServicePackage,
            isShowTop: showTopServicePackage,
            onTap: () => onShowTopServicePackage!(),),
        ],
      ),
    );
  }
}
