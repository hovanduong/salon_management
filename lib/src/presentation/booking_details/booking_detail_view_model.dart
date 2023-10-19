import 'dart:async';

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/booking_details_language.dart';
import '../../configs/widget/dialog/warnig_network_dialog.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/my_booking_model.dart';
import '../../resource/service/invoice.dart';
import '../../resource/service/my_booking.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class BookingDetailsViewModel extends BaseViewModel{
  bool isLoading=true;
  bool isShowListService=true;

  Timer? timer;

  MyBookingParams? dataMyBooking;

  MyBookingApi myBookingApi = MyBookingApi();
  InvoiceApi invoiceApi = InvoiceApi();

  List<MyBookingModel> listMyBooking = [];

  Future<void> init(MyBookingParams params)async{
    await getMyBookingUser(params.id.toString());
    dataMyBooking=params;
    isLoading=false;
    notifyListeners();
  }

  Future<void> goToBill(BuildContext context) 
    => Navigator.pushNamed(context, Routers.bill, 
      arguments: listMyBooking[0].total,);

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
    timer= Timer(const Duration(seconds: 1), () {
      goToBill(context); });
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

  dynamic showWaningDiaglog(int id){
    showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: BookingDetailsLanguage.waningPayment,
          leftButtonName: BookingDetailsLanguage.cancel,
          onTapLeft: () {
            Navigator.pop(context);
          },
          rightButtonName: BookingDetailsLanguage.confirm,
          onTapRight: (){
            postInvoice(id);
            Navigator.pop(context);
          },
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
      isLoading = true;
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      listMyBooking = value as List<MyBookingModel>;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> postInvoice(int id) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await invoiceApi.postInvoice(InvoiceParams(id: id));

    final value = switch (result) {
      Success(value: final isBool) => isBool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      await putStatusAppointment(id, 'Done');
    }
    notifyListeners();
  }

  Future<void> putStatusAppointment(int id, String status) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await myBookingApi.putStatusAppointment(
      MyBookingParams(
        id: id,
        status: status,
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
      showSuccessDiaglog(context);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
