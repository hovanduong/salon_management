import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/configs.dart';
import '../../configs/widget/dialog/warnig_network_dialog.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/my_booking_model.dart';
import '../../resource/service/my_booking.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class Contains{
  static const confirmed = 'Confirmed';
  static const canceled = 'Canceled';
  static const done = 'Done';
}

class BookingHistoryViewModel extends BaseViewModel {
  MyBookingApi myBookingApi = MyBookingApi();

  ScrollController scrollUpComing = ScrollController();
  ScrollController scrollDone = ScrollController();
  ScrollController scrollCanceled = ScrollController();


  List<MyBookingModel> listMyBooking = [];
  List<MyBookingModel> listCurrentUpcoming = [];
  List<MyBookingModel> listCurrentToday = [];
  List<MyBookingModel> listCurrentDone = [];
  List<MyBookingModel> listCurrentCanceled = [];

  bool isLoadMore = false;
  bool isLoading = true;
  bool isToday=true;

  int pageUpComing = 1;
  int pageDone = 1;
  int pageCanceled = 1;
  int pageToday=1;

  Timer? timer;

  String status = Contains.confirmed;

  Future<void> init() async {
    await fetchData();
  }

  Future<void> goToAddBooking({
    required BuildContext context,
    MyBookingModel? myBookingModel,
  }) =>
      Navigator.pushNamed(
        context,
        Routers.addBooking,
        arguments: myBookingModel,
      );

  Future<void> goToBookingDetails(BuildContext context, MyBookingParams model) 
    => Navigator.pushNamed(context, Routers.bookingDetails, arguments: model);

  Future<void> fetchData() async {
    listCurrentUpcoming.clear();
    pageToday = 1;
    pageUpComing = 1;
    pageDone = 1;
    pageCanceled = 1;

    await getMyBooking(page: pageToday,
      status: Contains.confirmed, isToday: true,);
    listCurrentToday = listMyBooking;

    await getMyBooking(page: pageUpComing,status: Contains.confirmed);
    listCurrentUpcoming = listMyBooking;

    await getMyBooking(page: pageCanceled,status: Contains.canceled);
    listCurrentCanceled = listMyBooking;

    await getMyBooking(page: pageDone,status: Contains.done);
    listCurrentDone = listMyBooking;

    isLoading = false;
    scrollUpComing.addListener(() => scrollListener(scrollUpComing),);
    // scrollCanceled.addListener(() => scrollListener(scrollCanceled),);
    // scrollDone.addListener(() => scrollListener(scrollDone),);

    notifyListeners();
  }

  Future<void> pullRefresh() async {
    await init();
    isLoadMore = false;
    notifyListeners();
  }

  dynamic scrollListener(ScrollController scrollController) async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      isLoadMore = true;
      Future.delayed(const Duration(seconds: 2), loadMoreData);
    }
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    if (status == Contains.confirmed) {
      if(isToday){
        pageToday+=1;
        await getMyBooking(page: pageToday,
          status: Contains.confirmed, isToday: true,);
        listCurrentToday = [...listCurrentToday, ...listMyBooking];
      }else{
        pageUpComing += 1;
        await getMyBooking(page: pageUpComing,status: status);
        listCurrentUpcoming = [...listCurrentUpcoming, ...listMyBooking];
      }
    } else if (status == Contains.canceled) {
      pageCanceled += 1;
      await getMyBooking(page: pageCanceled,status: status);
      listCurrentCanceled = [...listCurrentCanceled, ...listMyBooking];
    } else {
      pageDone += 1;
      await getMyBooking(page: pageDone,status: status);
      listCurrentDone = [...listCurrentDone, ...listMyBooking];
    }
    isLoadMore = false;

    notifyListeners();
  }

  Future<void> setStatus(int value) async {
    // await pullRefresh();
    if (value == 0) {
      status = Contains.confirmed;
      isToday=true;
    } else if (value == 1) {
      status = Contains.confirmed;
      isToday=false;
    } else if (value == 2) {
      status = Contains.done;
    } else {
      status = Contains.canceled;
    }
    notifyListeners();
  }

  void dialogStatus({required BuildContext context, String? value, int? id}) {
    if (value!.contains(Contains.confirmed)) {
      showDialogStatus(
        context: context,
        content: HistoryLanguage.confirmAppointment,
        title: HistoryLanguage.confirm,
        status: value,
        id: id,
      );
    } else {
      showDialogStatus(
        context: context,
        content: HistoryLanguage.cancelAppointment,
        title: HistoryLanguage.cancel,
        status: value,
        id: id,
      );
    }
  }

  Future<void> sendPhone(String phoneNumber, String scheme) async {
    print(phoneNumber);
    final launchUri = Uri(
      scheme: scheme,
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  dynamic showWaningDiaglog(int id){
    showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: BookingLanguage.waningDeleteBooking,
          leftButtonName: SignUpLanguage.cancel,
          onTapLeft: () {
            Navigator.pop(context);
          },
          rightButtonName: BookingLanguage.yes,
          onTapRight: (){
            deleteBookingHistory(id);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  dynamic showDialogStatus({
    required BuildContext context,
    String? content,
    String? title,
    int? id,
    String? status,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          image: AppImages.icPlus,
          content: content,
          title: title,
          leftButtonName: SignUpLanguage.cancel,
          rightButtonName: HistoryLanguage.confirmed,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          onTapLeft: () => Navigator.pop(context),
          onTapRight: () async {
            Navigator.pop(context);
            await putStatusAppointment(id!, status!);
          },
        );
      },
    );
  }

  void closeDialog(BuildContext context){
    timer= Timer(const Duration(seconds: 1), () => Navigator.pop(context),);
  }

  dynamic showSuccessDiaglog(_) {
    showDialog(
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

  Future<void> getMyBooking({int? page, String? status, bool isToday=false}) 
  async {
    final result = await myBookingApi.getMyBooking(
      MyBookingParams(
        page: page,
        status: status,
        isToday: isToday,
      ),
    );

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
      await fetchData();
    }
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
      showSuccessDiaglog(context);
      await pullRefresh();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
