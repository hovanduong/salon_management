import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/homepage_language.dart';
import '../../resource/model/model.dart';
import '../../resource/service/invoice.dart';
import '../../utils/app_valid.dart';
import '../../utils/date_format_utils.dart';
import '../base/base.dart';

class HomeViewModel extends BaseViewModel{

  InvoiceApi invoiceApi = InvoiceApi();

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

  bool isLoading=true;
  bool isShowBalance=true;
  bool isShowTransaction=true;
  bool loadingMore = false;

  int page=1;

  Future<void> init()async {
    page=1;
    await getInvoice(page);
    listCurrent=listInvoice;
    scrollController.addListener(scrollListener,);
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    page += 1;
    await getInvoice(page,);
    listCurrent = [...listCurrent, ...listInvoice];
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

  void setShowBalance(){
    isShowBalance=!isShowBalance;
    notifyListeners();
  }

  void setShowTransaction(){
    isShowTransaction=!isShowTransaction;
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
      isLoading = false;
      listInvoice = value as List<InvoiceOverViewModel>;
    }
    isLoading = false;
    notifyListeners();
  }

}
