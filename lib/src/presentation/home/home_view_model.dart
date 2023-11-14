// ignore_for_file: use_if_null_to_convert_nulls_to_bools

import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/homepage_language.dart';
import '../../resource/model/model.dart';
import '../../resource/service/invoice.dart';
import '../../resource/service/report_api.dart';
import '../../utils/app_currency.dart';
import '../../utils/app_valid.dart';
import '../../utils/date_format_utils.dart';
import '../../utils/time_zone.dart';
import '../base/base.dart';
import '../routers.dart';

class HomeViewModel extends BaseViewModel{

  InvoiceApi invoiceApi = InvoiceApi();
  ReportApi reportApi= ReportApi();

  ScrollController scrollController=ScrollController();

  List colors = [
    AppColors.COLOR_TEAL,
    AppColors.COLOR_OLIVE,
    AppColors.COLOR_MAROON,
    AppColors.COLOR_GREEN_LIST,
    AppColors.COLOR_PURPLE,
    AppColors.PRIMARY_PINK,
  ];

  List<InvoiceOverViewModel> listInvoice=[];
  List<InvoiceOverViewModel> listCurrent=[];
  List<ExpenseManagementModel> expenseManagement=[];

  bool isLoading=true;
  bool isShowBalance=true;
  bool isShowTransaction=true;
  bool loadingMore = false;

  int page=1;

  String? totalBalance;
  String? totalIncome;
  String? totalExpenses;

  Future<void> init()async {
    page=1;
    await getInvoice(page);
    listCurrent=listInvoice;
    await getExpenseManagement(DateTime.now().toString());
    scrollController.addListener(scrollListener,);
    notifyListeners();
  }

  Future<void> goToAddInvoice(BuildContext context) =>
      Navigator.pushNamed(context, Routers.payment);

  Future<void> goToCalendar() 
    => Navigator.pushNamed(context, Routers.calendar, arguments: true);

  Future<void> loadMoreData() async {
    page += 1;
    await getInvoice(page,);
    listCurrent = [...listCurrent, ...listInvoice];
    isLoading=false;
    notifyListeners();
  }

   dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      loadingMore = true;
      Future.delayed(const Duration(seconds: 2), () {
        loadMoreData();
        loadingMore = false;
      });
      notifyListeners();
    }
  }

  Future<void> pullRefresh()async{
    await init();
    notifyListeners();
  }

  String setDayOfWeek(int index){
    final now = AppDateUtils.parseDate(listCurrent[index].date);
    final dayOfWeek = now.weekday;
    switch (dayOfWeek) {
      case 1:
        return HomePageLanguage.monday;
      case 2:
        return HomePageLanguage.tuesday;
      case 3:
        return HomePageLanguage.wednesday;
      case 4:
        return HomePageLanguage.thursday;
      case 5:
        return HomePageLanguage.friday;
      case 6:
        return HomePageLanguage.saturday;
      case 7:
        return HomePageLanguage.sunday;
      default:
        return '';
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

  void setShowBalance(){
    isShowBalance=!isShowBalance;
    notifyListeners();
  }

  void setShowTransaction(){
    isShowTransaction=!isShowTransaction;
    notifyListeners();
  }

  void setMoney(){
    expenseManagement.forEach((element) {
      if(element.revenue==true){
        totalBalance=AppCurrencyFormat.formatMoney(element.money);
      }else if(element.income==true){
        totalIncome=AppCurrencyFormat.formatMoney(element.money);
      }else{
        totalExpenses=AppCurrencyFormat.formatMoney(element.money);
      }
    });
    notifyListeners();
  }

  Future<void> getInvoice(int page) async {
    final result = await invoiceApi.getInvoice(
      InvoiceParams(
        page: page,
      ),
    );

    final value = switch (result) {
      Success(value: final isBool) => isBool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading = true;
    } else if (value is Exception) {
      isLoading = true;
    } else {
      listInvoice = value as List<InvoiceOverViewModel>;
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
      await showErrorDialog(context);
    } else {
      expenseManagement=value as List<ExpenseManagementModel>;
      setMoney();
    }
    isLoading=false;
    notifyListeners();
  }

}
