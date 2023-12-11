import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/model/model.dart';
import '../../resource/service/invoice.dart';
import '../../resource/service/my_booking.dart';
import '../base/base.dart';
import '../routers.dart';

class DebtDetailViewModel extends BaseViewModel{
  bool isShowListService=true;
  bool isLoading=false;

  Timer? timer;

  MyBookingApi myBookingApi = MyBookingApi();
  InvoiceApi invoiceApi = InvoiceApi();

  OwesModel? owesModel;

  Future<void> init(OwesModel params)async{
    owesModel=params;
    notifyListeners();
  }

  Future<void> goToHome() => Navigator.pushReplacementNamed(
    context, Routers.home,);

  void closeDialog(BuildContext context){
    Timer(const Duration(seconds: 1), () => Navigator.pop(context),);
    notifyListeners();
  }

  void showListService(){
    isShowListService=!isShowListService;
    notifyListeners();
  }

  dynamic showSuccessDiaglog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
        );
      },
    );
    timer= Timer(const Duration(seconds: 1), goToHome);
    notifyListeners();
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
