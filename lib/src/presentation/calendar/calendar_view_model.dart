// ignore_for_file: avoid_bool_literals_in_conditional_expressions, avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/model/model.dart';
import '../../resource/service/report_api.dart';
import '../../utils/app_valid.dart';
import '../../utils/time_zone.dart';
import '../base/base.dart';

class CalendarViewModel extends BaseViewModel{

  ReportApi reportApi= ReportApi();

  List<ReportModel>? reportModel;
  List<ExpenseManagementModel>? expenseManagement;
  List<ReportModel> listDay=[];

  bool isLoading=true;
  bool isWeekend=false;
  bool isDayCurrent=false;
  bool isOverView=false;

  String? monthOfYear;

  int month=DateTime.now().month;
  int year=DateTime.now().year;

  num revenue=0;
  num spendingMoney=0;
  num total=0;

  Future<void> init(bool? isScreen)async{
    isOverView=isScreen ?? false;
    await getList();
    notifyListeners();
  }

  Future<void> subMonth()async{
    if(month>1){
      month--;
    }else{
      month=12;
      year--;
    }
    await getList();
    notifyListeners();
  }

  Future<void> addMonth()async{
    if(month<12){
      month++;
    }else{
      month=1;
      year++;
    }
    await getList();
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
    final date= DateTime.now().toString();
    if(day<10){
      return date.contains('$year-$month-0$day');
    }else{
      return date.contains('$year-$month-$day');
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
      await showDialogNetwork(context);
    } else if (value is Exception) {
      isLoading=false;
      await showErrorDialog(context);
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
      date: date,
    ),);

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      await showDialogNetwork(context);
    } else if (value is Exception) {
      isLoading=false;
      await showErrorDialog(context);
    } else {
      isLoading=false;
      expenseManagement=value as List<ExpenseManagementModel>;
    }
    notifyListeners();
  }
}
