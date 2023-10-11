
// ignore_for_file: avoid_positional_boolean_parameters, parameter_assignments

// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

import 'package:intl/intl.dart';

import '../../configs/configs.dart';
import '../../configs/widget/dialog/warnig_network_dialog.dart';
import '../../resource/model/model.dart';
import '../../resource/model/revenue_chart_model.dart';
import '../../resource/service/income_api.dart';
import '../../utils/app_valid.dart';
import '../../utils/time_zone.dart';
import '../base/base.dart';

class HomePageViewModel extends BaseViewModel{
  List<RevenueChartModel> dataChart = [];
  List<ChartDataModel> data = [];

  StatisticsModel? statisticsModel;

  IncomeApi incomeApi= IncomeApi();

  bool showRevenue=false;
  bool showTopService=false;
  bool showTopServicePackage=false;
  bool isLoading=true;

  num? totalRevenue;
  num? growthRevenue;
  num? totalBeforeRevenue;
  num? totalAppointmentConfirm;
  num? totalBeforeAppointmentConfirm;
  num? growthAppointmentConfirm;
  num? totalAppointmentCancel;
  num? totalBeforeAppointmentCancel;
  num? growthAppointmentCancel;
  num? totalClient;
  num? totalBeforeClient;
  num? growthClient;

  String date= DateFormat('dd/MM/yyyy').format(DateTime.now());

  dynamic init() {
    fetchData();
  }

  Future<void> fetchData() async{
    data = [
      ChartDataModel(day: '22',revenue: 3500),
      ChartDataModel(day: '23',revenue: 1600),
      ChartDataModel(day: '24',revenue: 2500),
      ChartDataModel(day: '25',revenue: 3000),
      ChartDataModel(day: '26',revenue: 2930),
      ChartDataModel(day: '27',revenue: 4000),
      ChartDataModel(day: '28',revenue: 6000),
    ];
    isLoading=true;
    await getIncome();
    await getRevenueChart();
    setDataPageToday();
    notifyListeners();
  }

  void setDataPageYesterday(){
    totalRevenue = statisticsModel!.statisticsYesterday!.revenue!.currentCount;
    totalBeforeRevenue=statisticsModel!.statisticsYesterday!.revenue!.beforeCount;
    growthRevenue= statisticsModel!.statisticsYesterday!.revenue!.pctInc;
    totalAppointmentConfirm= statisticsModel!.statisticsYesterday!
      .appointmentConfirmedCount!.currentCount;
    totalBeforeAppointmentConfirm= statisticsModel!.statisticsYesterday!
      .appointmentConfirmedCount!.beforeCount;
    growthAppointmentConfirm= statisticsModel
      !.statisticsYesterday!.appointmentConfirmedCount!.pctInc;
    totalAppointmentCancel=  statisticsModel!.statisticsYesterday
      !.appointmentCanceledCount!.currentCount;
    totalBeforeAppointmentCancel=  statisticsModel!.statisticsYesterday
      !.appointmentCanceledCount!.beforeCount;
    growthAppointmentCancel= statisticsModel!.statisticsYesterday
      !.appointmentCanceledCount!.pctInc;
    totalClient= statisticsModel!.statisticsYesterday
      !.customerCount!.currentCount;
    totalBeforeClient= statisticsModel!.statisticsYesterday
      !.customerCount!.beforeCount;
    growthClient= statisticsModel!.statisticsYesterday!.customerCount!.pctInc;
    notifyListeners();
  }

  void setDataPageToday(){
    totalRevenue = statisticsModel!.statisticsToday!.revenue!.currentCount;
    totalBeforeRevenue=statisticsModel!.statisticsToday!.revenue!.beforeCount;
    growthRevenue= statisticsModel!.statisticsToday!.revenue!.pctInc;
    totalAppointmentConfirm= statisticsModel!.statisticsToday!
      .appointmentConfirmedCount!.currentCount;
    totalBeforeAppointmentConfirm= statisticsModel!.statisticsToday!
      .appointmentConfirmedCount!.beforeCount;
    growthAppointmentConfirm= statisticsModel
      !.statisticsToday!.appointmentConfirmedCount!.pctInc;
    totalAppointmentCancel=  statisticsModel!.statisticsToday
      !.appointmentCanceledCount!.currentCount;
    totalBeforeAppointmentCancel=  statisticsModel!.statisticsToday
      !.appointmentCanceledCount!.beforeCount;
    growthAppointmentCancel= statisticsModel!.statisticsToday
      !.appointmentCanceledCount!.pctInc;
    totalClient= statisticsModel!.statisticsToday
      !.customerCount!.currentCount;
    totalBeforeClient= statisticsModel!.statisticsToday
      !.customerCount!.beforeCount;
    growthClient= statisticsModel!.statisticsToday!.customerCount!.pctInc;
    notifyListeners();
  }

  void setDataPageWeek(){
    totalRevenue = statisticsModel!.statisticsWeek!.revenue!.currentCount;
    totalBeforeRevenue=statisticsModel!.statisticsWeek!.revenue!.beforeCount;
    growthRevenue= statisticsModel!.statisticsWeek!.revenue!.pctInc;
    totalAppointmentConfirm= statisticsModel!.statisticsWeek!
      .appointmentConfirmedCount!.currentCount;
    totalBeforeAppointmentConfirm= statisticsModel!.statisticsWeek!
      .appointmentConfirmedCount!.beforeCount;
    growthAppointmentConfirm= statisticsModel
      !.statisticsWeek!.appointmentConfirmedCount!.pctInc;
    totalAppointmentCancel=  statisticsModel!.statisticsWeek
      !.appointmentCanceledCount!.currentCount;
    totalBeforeAppointmentCancel=  statisticsModel!.statisticsWeek
      !.appointmentCanceledCount!.beforeCount;
    growthAppointmentCancel= statisticsModel!.statisticsWeek
      !.appointmentCanceledCount!.pctInc;
    totalClient= statisticsModel!.statisticsWeek
      !.customerCount!.currentCount;
    totalBeforeClient= statisticsModel!.statisticsWeek
      !.customerCount!.beforeCount;
    growthClient= statisticsModel!.statisticsWeek!.customerCount!.pctInc;
    notifyListeners();
  }

  void setDataPageMonth(){
    totalRevenue = statisticsModel!.statisticsMonth!.revenue!.currentCount;
    totalBeforeRevenue=statisticsModel!.statisticsMonth!.revenue!.beforeCount;
    growthRevenue= statisticsModel!.statisticsMonth!.revenue!.pctInc;
    totalAppointmentConfirm= statisticsModel!.statisticsMonth!
      .appointmentConfirmedCount!.currentCount;
    totalBeforeAppointmentConfirm= statisticsModel!.statisticsMonth!
      .appointmentConfirmedCount!.beforeCount;
    growthAppointmentConfirm= statisticsModel
      !.statisticsMonth!.appointmentConfirmedCount!.pctInc;
    totalAppointmentCancel=  statisticsModel!.statisticsMonth
      !.appointmentCanceledCount!.currentCount;
    totalBeforeAppointmentCancel=  statisticsModel!.statisticsMonth
      !.appointmentCanceledCount!.beforeCount;
    growthAppointmentCancel= statisticsModel!.statisticsMonth
      !.appointmentCanceledCount!.pctInc;
    totalClient= statisticsModel!.statisticsMonth
      !.customerCount!.currentCount;
    totalBeforeClient= statisticsModel!.statisticsMonth
      !.customerCount!.beforeCount;
    growthClient= statisticsModel!.statisticsMonth!.customerCount!.pctInc;
    notifyListeners();
  }

  void setDataPage(int value){
    final day=DateTime.now();
    isLoading=true;
    if(value==0){
      setDataPageYesterday();
      date='${day.day-1}/${day.month}/${day.year}/${day.weekday}';
    }else if(value==1){
      setDataPageToday();
      date=DateFormat('dd/MM/yyyy').format(DateTime.now());
    }else if(value==2){
      setDataPageWeek();
      date='';
    }else{
      setDataPageMonth();
    }
    isLoading=false;
    notifyListeners();
  }

  void showListRevenue(){
    showRevenue=!showRevenue;
    notifyListeners();
  }

  void showListTopService(){
    showTopService=!showTopService;
    notifyListeners();
  }

  void showListTopServicePackage(){
    showTopServicePackage=!showTopServicePackage;
    notifyListeners();
  }

  Future<void> getIncome() async {
    final result = await incomeApi.getIncome(IncomeParams(
      timeZone: MapLocalTimeZone.mapLocalTimeZoneToSpecificTimeZone(
        DateTime.now().timeZoneName,),
    ),);

    final value = switch (result) {
      Success(value: final model) => model,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      statisticsModel = value as StatisticsModel;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getRevenueChart() async {
    final result = await incomeApi.getRevenueChart(IncomeParams(
      timeZone: MapLocalTimeZone.mapLocalTimeZoneToSpecificTimeZone(
        DateTime.now().timeZoneName,),
      endDate: '2023-10-10 ',
      startDate: '2023-10-04',
    ),);

    final value = switch (result) {
      Success(value: final listRevenueChart) => listRevenueChart,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      dataChart = value as List<RevenueChartModel>;
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
