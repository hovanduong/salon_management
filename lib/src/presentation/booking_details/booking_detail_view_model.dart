// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/app_result/app_result.dart';
import '../../configs/configs.dart';
import '../../configs/widget/dialog/warnig_network_dialog.dart';
import '../../resource/model/my_booking_model.dart';
import '../../resource/service/invoice.dart';
import '../../resource/service/my_booking.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class BookingDetailsViewModel extends BaseViewModel{
  bool isLoading=true;
  MyBookingParams? dataMyBooking;

  MyBookingApi myBookingApi = MyBookingApi();
  InvoiceApi invoiceApi = InvoiceApi();

  List<MyBookingModel> listMyBooking = [];

  late Timer timer;

  Future<void> init(MyBookingParams params)async{
    await getMyBookingUser(params.id.toString());
    dataMyBooking=params;
    isLoading=false;
    notifyListeners();
  }

  Future<void> goToHome(BuildContext context) 
    => Navigator.pushNamed(context, Routers.navigation);

  void closeDialog(BuildContext context){
    final timer= Timer(const Duration(seconds: 1), () => Navigator.pop(context),);
    timer.cancel();
  }

  dynamic showSuccessDiaglog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        timer = Timer(const Duration(seconds: 1), () {
          goToHome(context); });
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
        );
      },
    );
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

  Future<void> getMyBookingUser(String id) async {
    final result = await myBookingApi.getMyBookingUser(id);

    final value = switch (result) {
      Success(value: final listMyBooking) => listMyBooking,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      // showDialogNetwork(context);
    } else if (value is Exception) {
      // showErrorDialog(context);
    } else {
      listMyBooking = value as List<MyBookingModel>;
    }
    notifyListeners();
  }

  Future<void> postInvoice(int id) async {
    final result = await invoiceApi.postInvoice(InvoiceParams(id: id));

    final value = switch (result) {
      Success(value: final isBool) => isBool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDialog(context);
    } else {
      showSuccessDiaglog(context);
    }
    notifyListeners();
  }
}
