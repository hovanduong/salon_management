import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../configs/configs.dart';
import '../../resource/model/model.dart';
import '../../resource/service/income_api.dart';
import '../../resource/service/report_api.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../../utils/time_zone.dart';
import '../base/base.dart';
import '../routers.dart';


class CalendarViewModel extends BaseViewModel{

  ReportApi reportApi= ReportApi();

  DateRangePickerController dateController = DateRangePickerController();

  List<ReportModel>? reportModel;
  List<ExpenseManagementModel>? expenseManagement;
  List<ReportModel> listDay=[];

  bool isLoading=true;
  bool isWeekend=false;
  bool isDayCurrent=false;
  bool isShowCase=true;

  String? monthOfYear;

  int month=DateTime.now().month;
  int year=DateTime.now().year;
  int? day;
  int? isOverView;
  int? idUser;

  DateTime dateTime= DateTime.now();

  num revenue=0;
  num spendingMoney=0;
  num total=0;

  GlobalKey keyLastMonth=GlobalKey();
  GlobalKey keyNextMonth=GlobalKey();
  GlobalKey keyDailyRevenue=GlobalKey();
  GlobalKey keyMonthlyRevenue=GlobalKey();
  GlobalKey keySelectMonthYear=GlobalKey();

  Timer? timer;

  Future<void> init()async{
    idUser = int.parse(await AppPref.getDataUSer('id') ?? '0');
    await getList();
    await AppPref.getShowCase('showCaseRevenue$idUser').then(
      (value) => isShowCase=value??true,);
    startShowCase();
    await hideShowcase();
    notifyListeners();
  }

  Future<void> goToHome(BuildContext context, int day) =>
      Navigator.pushNamed(context, Routers.homeScreen, 
      arguments: IncomeParams(date: DateTime(year, month, day), 
        isDate: 1,),);

  Future<void> updateDateTime(DateTime date) async {
    dateTime= date;
    month = date.month;
    year =date.year;
    notifyListeners();
  }

  Future<void> hideShowcase() async{
    await AppPref.setShowCase('showCaseRevenue$idUser', false);
    isShowCase=false;
    notifyListeners();
  }

  void startShowCase(){
    if(isShowCase){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowCaseWidget.of(context).startShowCase(
          [keyLastMonth, keySelectMonthYear,keyNextMonth,  
            keyDailyRevenue, keyMonthlyRevenue],
        );
      });
    }
  }

  Future<void> subMonth()async{
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(const Duration(milliseconds: 500), () async{
      if(month>1){
        month--;
      }else{
        month=12;
        year--;
      }
      await getList();
      dateTime= DateTime(year, month, 1);
    });
    notifyListeners();
  }

  Future<void> addMonth()async{
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(const Duration(milliseconds: 500), () async{
      if(month<12){
        month++;
      }else{
        month=1;
        year++;
      }
      await getList();
      dateTime= DateTime(year, month, 1);
    });
    notifyListeners();
  }

  void setWeekend(int weekday){
    if(weekday==6 || weekday==7){
      isWeekend=true;
    }else{
      isWeekend=false;
    }
    notifyListeners();
  }

  void getDataDay(){
    final lastDay= DateTime(year, month+1, 0).day;
    final date= DateTime(year, month, 1);
    for(var i=0; i<reportModel!.length; i++){
      listDay.add(
        ReportModel(
          revenueDay: reportModel?[i].revenueDay,
          date: reportModel?[i].date,
          isCurrentDay: checkCurrentDay(i+1),
        ),
      );
    }
    for(var i=1; i<=(isWeekend?42:35 -lastDay-(date.weekday-2)); i++){
      listDay.add(ReportModel());
    }
    notifyListeners();
  }

  Future<void> getList()async{
    listDay.clear();
    final date= DateTime(year, month, 1);
    await getExpenseManagement(date.toString());
    if(date.weekday==1){
      setWeekend(date.weekday);
      await getReport(date.toString());
      getDataDay();
    } else{
      setWeekend(date.weekday);
      await getReport(date.toString());
      for(var i=date.weekday-2; i>=0; i--){
        listDay.add(ReportModel());
      }
      getDataDay();
    }
    notifyListeners();
  }

  bool checkCurrentDay(num day){
    final date= DateTime.now();
    if(date.month<10){
      if(day<10){
        return date.toString().contains('$year-0$month-0$day');
      }else{
        return date.toString().contains('$year-0$month-$day');
      }
    }else{
      if(day<10){
        return date.toString().contains('$year-0$month-0$day');
      }else{
        return date.toString().contains('$year-$month-$day');
      }
    }
  }

  dynamic showErrorDialog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
        );
      },
    );
  }

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> getReport(String date) async {
    isLoading=true;
    final result = await reportApi.getReport(ReportParams(
      timeZone: MapLocalTimeZone.mapLocalTimeZoneToSpecificTimeZone(
          DateTime.now().timeZoneName,
        ),
      date: date,
    ),);

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading=true;
    } else if (value is Exception) {
      isLoading=true;
    } else {
      isLoading=false;
      reportModel=value as List<ReportModel>;
    }
    notifyListeners();
  }

  Future<void> getExpenseManagement(String date) async {
    final result = await reportApi.getExpenseManagement(ReportParams(
      timeZone: MapLocalTimeZone.mapLocalTimeZoneToSpecificTimeZone(
          DateTime.now().timeZoneName,
        ),
      isDate: 0,
      date: date,
    ),);

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading=true;
    } else if (value is Exception) {
      isLoading=true;
    } else {
      expenseManagement=value as List<ExpenseManagementModel>;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
