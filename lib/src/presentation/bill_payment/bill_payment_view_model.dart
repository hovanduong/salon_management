import 'package:flutter/material.dart';

import '../../utils/date_format_utils.dart';
import '../base/base.dart';
import '../routers.dart';

class BillPaymentViewModel extends BaseViewModel{
  bool isShowTransaction= false;

  late String time;
  late String date;

  num? totalMoney;

  dynamic init(num? money){
    if(totalMoney != null){
      totalMoney=money;
    }
    time = AppDateUtils.formatDateTime('');
    date= AppDateUtils.formatTimeToHHMM(DateTime.now());
    notifyListeners();
  }

  Future<void> goToInvoice(BuildContext context) =>
      Navigator.pushReplacementNamed(context, Routers.navigation, arguments: 1);

  void showTransaction(){
    isShowTransaction=!isShowTransaction;
    notifyListeners();
  }
}
