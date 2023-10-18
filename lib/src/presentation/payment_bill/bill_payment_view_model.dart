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
    date = AppDateUtils.formatDateTime('');
    time= AppDateUtils.formatTimeToHHMM(DateTime.now());
    notifyListeners();
  }
  
  Future<void> goToInvoice() => Navigator.pushReplacementNamed(
      context,
      Routers.home,
      arguments: 1,
    );
  
  Future<void> goToHome() => Navigator.pushReplacementNamed(
      context,
      Routers.home,
    );

  void showTransaction(){
    isShowTransaction=!isShowTransaction;
    notifyListeners();
  }
}
