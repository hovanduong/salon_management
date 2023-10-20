import 'package:flutter/material.dart';

import '../../resource/model/model.dart';
import '../../utils/date_format_utils.dart';
import '../base/base.dart';
import '../routers.dart';

class BillPaymentViewModel extends BaseViewModel{
  bool isShowTransaction= true;

  late String time;
  late String date;
  String? dateTime;

  MyBookingModel? myBookingModel;

  Future<void> init(MyBookingModel? myBooking)async{
    myBookingModel=myBooking;
    time = AppDateUtils.formatTimeToHHMM(DateTime.now());
    date=AppDateUtils.formatDateTime('');
    dateTime='$time $date';
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
