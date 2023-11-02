// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/calendar_language.dart';
import '../base/base.dart';
import 'calendar.dart';
import 'components/components.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  
  CalendarViewModel? _viewModel;
  
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
      statusBarColor: AppColors.PRIMARY_GREEN, 
      ),
    );

    return BaseWidget(
      viewModel: CalendarViewModel(),
      onViewModelReady: (viewModel) => _viewModel=viewModel!..init(),
      builder: (context, viewModel, child) => buildLoading(),
    );
  }

  Widget buildLoading() {
    return Scaffold(
      body: StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.online,
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        child: NetworkAwareWidget(
          offlineChild: const ThreeBounceLoading(),
          onlineChild: Container(
            color: AppColors.COLOR_WHITE,
            child: Stack(
              children: [
                buildCalendarScreen(),
                if (_viewModel!.isLoading)
                  const Positioned(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: ThreeBounceLoading(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      color: AppColors.PRIMARY_GREEN,
      child: Padding(
        padding: EdgeInsets.only(
          top: Platform.isAndroid ? 40 : 60,
          bottom: 10,
          left: SizeToPadding.sizeMedium,
          right: SizeToPadding.sizeMedium,
        ),
        child: CustomerAppBar(
          color: AppColors.COLOR_WHITE,
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.COLOR_WHITE,
          ),
          onTap: () {
            Navigator.pop(context);
          },
          title: CalendarLanguage.calendar,
        ),
      ),
    );
  }

  Widget buildMonthCalendar(){
    return MonthCalendarWidget(
      month: '${_viewModel!.month}/${_viewModel!.year}',
      addMonth:() => _viewModel!.addMonth(),
      subMonth: () => _viewModel!.subMonth(),
    );
  }

  Widget buildCalendar(){
    return CalendarWidget(
      listDay: _viewModel!.getListDay(),
    );
  }

  Widget buildRevenue(){
    return TotalMoneyWidget(
      content: CalendarLanguage.revenue,
      money: _viewModel!.revenue,
      colorMoney: AppColors.Green_Money,
    );
  }
  
  Widget buildSpendingMoney(){
    return TotalMoneyWidget(
      content: CalendarLanguage.spendingMoney,
      money: _viewModel!.spendingMoney,
      colorMoney: AppColors.Red_Money,
    );
  }

   Widget buildTotal(){
    return TotalMoneyWidget(
      content: CalendarLanguage.total,
      money: _viewModel!.total,
      colorMoney: AppColors.Green_Money,
    );
  }

  Widget buildMoney(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildRevenue(),
          buildSpendingMoney(),
          buildTotal(),
        ],
      ),
    );
  }

  Widget buildDivider(){
    return const Divider(color: AppColors.BLACK_300,);
  }

  Widget buildCalendarScreen(){
    return SingleChildScrollView(
      child: Column(
        children: [
          buildHeader(),
          buildMonthCalendar(),
          buildCalendar(),
          buildDivider(),
          buildMoney(),
        ],
      ),
    );
  }
}
