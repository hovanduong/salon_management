// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

    final isScreen = ModalRoute.of(context)!.settings.arguments;
    return BaseWidget(
      viewModel: CalendarViewModel(),
      onViewModelReady: (viewModel) => _viewModel=viewModel!..init(
        isScreen as int?,),
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
          title: CalendarLanguage.report,
        ),
      ),
    );
  }

   Widget buildHeaderSecond() {
    return Container(
      color: AppColors.PRIMARY_GREEN,
      child: Padding(
        padding: EdgeInsets.only(top: Platform.isAndroid ? 20 : 40),
        child: ListTile(
          title: Center(
            child: Paragraph(
              content: CalendarLanguage.report,
              style: STYLE_LARGE.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  dynamic showSelectDate() {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
        child: SfDateRangePicker(
          controller: _viewModel!.dateController,
          selectionMode: DateRangePickerSelectionMode.single,
          initialSelectedDate: _viewModel!.dateTime,
          showActionButtons: true,
          showNavigationArrow: true,
          onCancel: () {
            _viewModel!.dateController.selectedDate = null;
            Navigator.pop(context);
          },
          onSubmit: (value) {
            _viewModel!.updateDateTime(value! as DateTime);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget buildMonthCalendar(){
    return InkWell(
      onTap: showSelectDate,
      child: MonthCalendarWidget(
        month: '${_viewModel!.month}/${_viewModel!.year}',
        addMonth:() => _viewModel!.addMonth(),
        subMonth: () => _viewModel!.subMonth(),
        keyLastMonth: _viewModel!.keyLastMonth,
        keyNextMonth: _viewModel!.keyNextMonth,
      ),
    );
  }

  Widget buildCalendar(){
    return Showcase(
      key: _viewModel!.keyDailyRevenue,
      description: CalendarLanguage.dailyRevenue,
      child: CalendarWidget(
        listDay: _viewModel?.listDay,
        isWeekend: _viewModel!.isWeekend,
      ),
    );
  }

   Widget buildTotal(int index){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width/3.1,
      child: TotalMoneyWidget(
        content: (_viewModel!.expenseManagement?[index].revenue ?? false)
          ? CalendarLanguage.total
          : (_viewModel!.expenseManagement?[index].income?? false) ?
            CalendarLanguage.revenue : CalendarLanguage.spendingMoney,
        money: _viewModel!.expenseManagement?[index].money,
        colorMoney: (_viewModel!.expenseManagement?[index].income ?? false
          || (_viewModel!.expenseManagement?[index].revenue ?? false))
          ? AppColors.Green_Money : AppColors.Red_Money,
      ),
    );
  }

  Widget buildMoney(){
    return _viewModel!.listDay.isNotEmpty? Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
      child: Showcase(
        key: _viewModel!.keyMonthlyRevenue,
        description: CalendarLanguage.monthlyRevenue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_viewModel!.expenseManagement!.length, 
            buildTotal,
          ),
        ),
      ),
    ): Container();
  }

  Widget buildDivider(){
    return const Divider(color: AppColors.BLACK_300,);
  }

  Widget buildCalendarScreen(){
    return SingleChildScrollView(
      child: Column(
        children: [
          if (_viewModel!.isOverView==1) buildHeader() 
          else buildHeaderSecond(),
          buildMonthCalendar(),
          buildCalendar(),
          buildDivider(),
          buildMoney(),
        ],
      ),
    );
  }
}
