// ignore_for_file: avoid_positional_boolean_parameters, parameter_assignments

// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/widget/dialog/warnig_network_dialog.dart';
import '../../resource/model/model.dart';
import '../../resource/service/income_api.dart';
import '../../utils/app_valid.dart';
import '../../utils/check_date.dart';
import '../../utils/time_zone.dart';
import '../base/base.dart';
import '../routers.dart';

class OverViewViewModel extends BaseViewModel {
  List<RevenueChartModel> dataChart = [];
  List<DataTopService> topService = [];

  StatisticsModel? statisticsModel;
  StatisticsServiceModel? statisticsServiceModel;

  IncomeApi incomeApi = IncomeApi();

  bool showRevenue = false;
  bool showTopService = false;
  bool showTopServicePackage = false;
  bool isLoading = true;

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

  int? daysInterval;

  String date = AppCheckDate.formatDate(DateTime.now());
  String? dayStart;
  String? dayEnd;

  TabController? tabController;

  int currentTab=1;

  Timer? _timer;

  dynamic init({dynamic dataThis}) {
    _startDelay();
    tabController = TabController(length: 4, vsync: dataThis, initialIndex: 1);
    tabController!.addListener(handleTabChange);
  }

  Future<void> goToCalendar() 
    => Navigator.pushNamed(context, Routers.calendar);

  void handleTabChange(){
    final currentIndex = tabController!.index;
    print(currentIndex);
    setDataPage(currentIndex);
    notifyListeners();
  }

  void setPage(){
    tabController!.animation?.addListener(() async{
      final indexCurrent= tabController!.animation!.value.round();
      await setDataPage(indexCurrent);
    });
  }

  Timer _startDelay() =>
      _timer = Timer(const Duration(milliseconds: 1000), fetchData);

  Future<void> fetchData() async {
    isLoading = true;
    await getIncome();
    await getRevenueChart(date);
    await getTopService(AppCheckDate.formatYMD(date));
    notifyListeners();
  }

  Future<void> pullRefresh() async {
    await setDataPage(currentTab);
    notifyListeners();
  }

  void setDataPageYesterday() {
    totalRevenue = statisticsModel?.statisticsYesterday!.revenue!.currentCount;
    totalBeforeRevenue =
        statisticsModel?.statisticsYesterday!.revenue!.beforeCount;
    growthRevenue = statisticsModel?.statisticsYesterday!.revenue!.pctInc;
    totalAppointmentConfirm = statisticsModel
        ?.statisticsYesterday!.appointmentConfirmedCount!.currentCount;
    totalBeforeAppointmentConfirm = statisticsModel
        ?.statisticsYesterday!.appointmentConfirmedCount!.beforeCount;
    growthAppointmentConfirm =
        statisticsModel?.statisticsYesterday!.appointmentConfirmedCount!.pctInc;
    totalAppointmentCancel = statisticsModel
        ?.statisticsYesterday!.appointmentCanceledCount!.currentCount;
    totalBeforeAppointmentCancel = statisticsModel
        ?.statisticsYesterday!.appointmentCanceledCount!.beforeCount;
    growthAppointmentCancel =
        statisticsModel?.statisticsYesterday!.appointmentCanceledCount!.pctInc;
    totalClient =
        statisticsModel?.statisticsYesterday!.customerCount!.currentCount;
    totalBeforeClient =
        statisticsModel?.statisticsYesterday!.customerCount!.beforeCount;
    growthClient = statisticsModel?.statisticsYesterday!.customerCount!.pctInc;
    notifyListeners();
  }

  void setDataPageToday() {
    totalRevenue = statisticsModel?.statisticsToday!.revenue!.currentCount;
    totalBeforeRevenue = statisticsModel?.statisticsToday!.revenue!.beforeCount;
    growthRevenue = statisticsModel?.statisticsToday!.revenue!.pctInc;
    totalAppointmentConfirm = statisticsModel
        ?.statisticsToday!.appointmentConfirmedCount!.currentCount;
    totalBeforeAppointmentConfirm = statisticsModel
        ?.statisticsToday!.appointmentConfirmedCount!.beforeCount;
    growthAppointmentConfirm =
        statisticsModel?.statisticsToday!.appointmentConfirmedCount!.pctInc;
    totalAppointmentCancel = statisticsModel
        ?.statisticsToday!.appointmentCanceledCount!.currentCount;
    totalBeforeAppointmentCancel =
        statisticsModel?.statisticsToday!.appointmentCanceledCount!.beforeCount;
    growthAppointmentCancel =
        statisticsModel?.statisticsToday!.appointmentCanceledCount!.pctInc;
    totalClient = statisticsModel?.statisticsToday!.customerCount!.currentCount;
    totalBeforeClient =
        statisticsModel?.statisticsToday!.customerCount!.beforeCount;
    growthClient = statisticsModel?.statisticsToday!.customerCount!.pctInc;
    notifyListeners();
  }

  void setDataPageWeek() {
    totalRevenue = statisticsModel?.statisticsWeek!.revenue!.currentCount;
    totalBeforeRevenue = statisticsModel?.statisticsWeek!.revenue!.beforeCount;
    growthRevenue = statisticsModel?.statisticsWeek!.revenue!.pctInc;
    totalAppointmentConfirm = statisticsModel
        ?.statisticsWeek!.appointmentConfirmedCount!.currentCount;
    totalBeforeAppointmentConfirm =
        statisticsModel?.statisticsWeek!.appointmentConfirmedCount!.beforeCount;
    growthAppointmentConfirm =
        statisticsModel?.statisticsWeek!.appointmentConfirmedCount!.pctInc;
    totalAppointmentCancel =
        statisticsModel?.statisticsWeek!.appointmentCanceledCount!.currentCount;
    totalBeforeAppointmentCancel =
        statisticsModel?.statisticsWeek!.appointmentCanceledCount!.beforeCount;
    growthAppointmentCancel =
        statisticsModel?.statisticsWeek!.appointmentCanceledCount!.pctInc;
    totalClient = statisticsModel?.statisticsWeek!.customerCount!.currentCount;
    totalBeforeClient =
        statisticsModel?.statisticsWeek!.customerCount!.beforeCount;
    growthClient = statisticsModel?.statisticsWeek!.customerCount!.pctInc;
    notifyListeners();
  }

  void setDataPageMonth() {
    totalRevenue = statisticsModel?.statisticsMonth!.revenue!.currentCount;
    totalBeforeRevenue = statisticsModel?.statisticsMonth!.revenue!.beforeCount;
    growthRevenue = statisticsModel?.statisticsMonth!.revenue!.pctInc;
    totalAppointmentConfirm = statisticsModel
        ?.statisticsMonth!.appointmentConfirmedCount!.currentCount;
    totalBeforeAppointmentConfirm = statisticsModel
        ?.statisticsMonth!.appointmentConfirmedCount!.beforeCount;
    growthAppointmentConfirm =
        statisticsModel?.statisticsMonth!.appointmentConfirmedCount!.pctInc;
    totalAppointmentCancel = statisticsModel
        ?.statisticsMonth!.appointmentCanceledCount!.currentCount;
    totalBeforeAppointmentCancel =
        statisticsModel?.statisticsMonth!.appointmentCanceledCount!.beforeCount;
    growthAppointmentCancel =
        statisticsModel?.statisticsMonth!.appointmentCanceledCount!.pctInc;
    totalClient = statisticsModel?.statisticsMonth!.customerCount!.currentCount;
    totalBeforeClient =
        statisticsModel?.statisticsMonth!.customerCount!.beforeCount;
    growthClient = statisticsModel?.statisticsMonth!.customerCount!.pctInc;
    notifyListeners();
  }

  Future<void> setDataPage(int value) async {
    showRevenue = false;
    showTopService = false;
    showTopServicePackage = false;
    daysInterval = 15;
    if (value == 0) {
      currentTab=0;
      date = AppCheckDate.getDateBefore();
      await getRevenueChart(date);
      setDataPageYesterday();
      setTopServiceYesterday();
    } else if (value == 1) {
      currentTab=1;
      date = AppCheckDate.formatDate(DateTime.now());
      await getRevenueChart(date);
      setDataPageToday();
      setTopServiceToday();
    } else if (value == 2) {
      currentTab=2;
      date = AppCheckDate.getDateOfWeek();
      await getRevenueChart(date);
      setDataPageWeek();
      setTopServiceWeek();
    } else {
      currentTab=3;
      daysInterval = 30;
      date = AppCheckDate.getDateOfMonth();
      await getRevenueChart(date);
      setDataPageMonth();
      setTopServiceMonth();
    }
    isLoading = false;
    notifyListeners();
  }

  void showListRevenue() {
    showRevenue = !showRevenue;
    notifyListeners();
  }

  void showListTopService() {
    showTopService = !showTopService;
    notifyListeners();
  }

  void showListTopServicePackage() {
    showTopServicePackage = !showTopServicePackage;
    notifyListeners();
  }

  void setTopServiceToday() {
    topService.clear();
    statisticsServiceModel?.serviceNameDay?.serviceCounts?.entries.forEach(
      (e) {
        statisticsServiceModel?.serviceNameDay?.serviceMoney?.entries
            .forEach((element) {
          if (e.key.contains(element.key)) {
            topService.add(
              DataTopService(
                nameService: element.key,
                revenue: element.value,
                quantity: e.value,
              ),
            );
          }
        });
      },
    );
    topService.sort((a, b) => b.quantity!.compareTo(a.quantity!));
    notifyListeners();
  }

  void setTopServiceYesterday() {
    topService.clear();
    statisticsServiceModel?.serviceNameYesterDay?.serviceCounts?.entries
        .forEach(
      (e) {
        statisticsServiceModel?.serviceNameYesterDay?.serviceMoney?.entries
            .forEach((element) {
          if (e.key.contains(element.key)) {
            topService.add(
              DataTopService(
                nameService: element.key,
                revenue: element.value,
                quantity: e.value,
              ),
            );
          }
        });
      },
    );
    topService.sort((a, b) => b.quantity!.compareTo(a.quantity!));
    notifyListeners();
  }

  void setTopServiceWeek() {
    topService.clear();
    statisticsServiceModel?.serviceNameWeek?.serviceCounts?.entries.forEach(
      (e) {
        statisticsServiceModel?.serviceNameWeek?.serviceMoney?.entries
            .forEach((element) {
          if (e.key.contains(element.key)) {
            topService.add(
              DataTopService(
                nameService: element.key,
                revenue: element.value,
                quantity: e.value,
              ),
            );
          }
        });
      },
    );
    topService.sort((a, b) => b.quantity!.compareTo(a.quantity!));
    notifyListeners();
  }

  void setTopServiceMonth() {
    topService.clear();
    statisticsServiceModel?.serviceNameMonth?.serviceCounts?.entries.forEach(
      (e) {
        statisticsServiceModel?.serviceNameMonth?.serviceMoney?.entries
            .forEach((element) {
          if (e.key.contains(element.key)) {
            topService.add(
              DataTopService(
                nameService: element.key,
                revenue: element.value,
                quantity: e.value,
              ),
            );
          }
        });
      },
    );
    topService.sort((a, b) => b.quantity!.compareTo(a.quantity!));
    notifyListeners();
  }

  void setDateStartEnd(String date) {
    final endDay = AppCheckDate.addDate(date);
    dayStart = date.contains('-')
        ? AppCheckDate.addDate(date.split('-')[0].trim())
        : AppCheckDate.subtractDate(endDay);
    dayEnd = date.contains('-')
        ? AppCheckDate.addDate(date.split('-')[1].trim())
        : endDay;
    notifyListeners();
  }

  Future<void> getIncome() async {
    isLoading = true;
    final result = await incomeApi.getIncome(
      IncomeParams(
        timeZone: MapLocalTimeZone.mapLocalTimeZoneToSpecificTimeZone(
          DateTime.now().timeZoneName,
        ),
      ),
    );

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
      setDataPageToday();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getRevenueChart(String date) async {
    setDateStartEnd(date);
    final result = await incomeApi.getRevenueChart(
      IncomeParams(
        timeZone: MapLocalTimeZone.mapLocalTimeZoneToSpecificTimeZone(
          DateTime.now().timeZoneName,
        ),
        startDate: dayStart ?? '2023-10-04',
        endDate: dayEnd ?? '2023-10-10',
      ),
    );

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

  Future<void> getTopService(String date) async {
    isLoading = true;
    final result = await incomeApi.getTopRevenue(
      IncomeParams(
        startDate: date,
      ),
    );

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
      statisticsServiceModel = value as StatisticsServiceModel;
      setTopServiceToday();
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    tabController?.dispose();
    tabController!.removeListener(handleTabChange);
    super.dispose();
  }
}
