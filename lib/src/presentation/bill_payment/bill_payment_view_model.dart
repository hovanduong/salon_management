import 'package:flutter/material.dart';

import '../../utils/date_format_utils.dart';
import '../base/base.dart';
import '../routers.dart';

class BillPaymentViewModel extends BaseViewModel{
  bool isShowTransaction= true;

  late String time;
  late String date;

  num? totalMoney;

  Future<void> init(num? money)async{
    totalMoney=money;
    time = AppDateUtils.formatDateTime('');
    date= AppDateUtils.formatTimeToHHMM(DateTime.now());
    notifyListeners();
  }
  
  Future<void> goToInvoice() => Navigator.pushReplacementNamed(
      context,
      Routers.home,
      arguments: 1,
    );

  void showTransaction(){
    isShowTransaction=!isShowTransaction;
    notifyListeners();
  }
}
