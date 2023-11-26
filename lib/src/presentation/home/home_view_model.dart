// ignore_for_file: use_if_null_to_convert_nulls_to_bools

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/language/homepage_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';
import '../../resource/service/invoice.dart';
import '../../resource/service/my_booking.dart';
import '../../resource/service/report_api.dart';
import '../../utils/app_currency.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../../utils/date_format_utils.dart';
import '../../utils/time_zone.dart';
import '../base/base.dart';
import '../routers.dart';

class HomeViewModel extends BaseViewModel{

  InvoiceApi invoiceApi = InvoiceApi();
  ReportApi reportApi= ReportApi();
  MyBookingApi myBookingApi= MyBookingApi();

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
  bool? isShowCase;

  int page=1;

  String? totalBalance;
  String? totalIncome;
  String? totalExpenses;

  GlobalKey add= GlobalKey();
  GlobalKey cardMoney= GlobalKey();
  GlobalKey cardRevenue= GlobalKey();

  Future<void> init()async {
    isLoading=true;
    page=1;
    await getInvoice(page);
    listCurrent=listInvoice;
    await getExpenseManagement(DateTime.now().toString());
    scrollController.addListener(scrollListener,);
    await AppPref.getShowCase('showCaseHome').then(
      (value) => isShowCase=value??true,);
    startShowCase();
    await hideShowcase();
    notifyListeners();
  }

  Future<void> hideShowcase() async{
    await AppPref.setShowCase('showCaseHome', false);
    isShowCase=false;
    notifyListeners();
  }

  void startShowCase(){
    if(isShowCase==true){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        return ShowCaseWidget.of(context).startShowCase(
          [add, cardMoney, cardRevenue],);
      });
    }
  }

  Future<void> goToAddInvoice(BuildContext context) =>
      Navigator.pushNamed(context, Routers.payment);
  
  Future<void> goToEditInvoice(MyBookingModel myBookingModel) async {
    await Navigator.pushNamed(context, Routers.addBooking, 
      arguments: myBookingModel,
    );
    await init();
  }

  Future<void> goToBookingDetails(
          BuildContext context, MyBookingParams params,) =>
      Navigator.pushNamed(context, Routers.bookingDetails, arguments: params);

  Future<void> goToCalendar() 
    => Navigator.pushNamed(context, Routers.calendar, arguments: 1);

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

  dynamic showSuccessDialog(_) async{
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
        );
      },
    );
    await init();
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
        totalBalance=AppCurrencyFormat.formatMoneyVND(element.money ?? 0);
      }else if(element.income==true){
        totalIncome=AppCurrencyFormat.formatMoneyVND(element.money ?? 0);
      }else{
        totalExpenses=AppCurrencyFormat.formatMoneyVND(element.money ?? 0);
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

  Future<void> deleteBookingHistory(int id) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await myBookingApi.deleteBookingHistory(
      MyBookingParams(
        id: id,
      ),
    );

    final value = switch (result) {
      Success(value: final bool) => bool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      showSuccessDialog(context);
    }
    notifyListeners();
  }

}