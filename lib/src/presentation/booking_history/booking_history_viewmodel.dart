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
  ScrollController scrollToday = ScrollController();
  ScrollController scrollDaysBefore= ScrollController();

  List<MyBookingModel> listMyBooking = [];
  List<MyBookingModel> listCurrentUpcoming = [];
  List<MyBookingModel> listCurrentToday = [];
  List<MyBookingModel> listCurrentDone = [];
  List<MyBookingModel> listCurrentCanceled = [];
  List<MyBookingModel> listCurrentDaysBefore= [];

  bool isLoadMore = false;
  bool isLoading = true;
  bool isToday=true;

  int pageUpComing = 1;
  int pageDone = 1;
  int pageCanceled = 1;
  int pageToday=1;
  int pageDaysBefore=1;
  int currentTab=0;

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
    listCurrentCanceled.clear();
    listCurrentDone.clear();
    listCurrentToday.clear();
    listCurrentDaysBefore.clear();
    pageToday = 1;
    pageUpComing = 1;
    pageDone = 1;
    pageCanceled = 1;
    pageDaysBefore=1;

    await getDataDaysBefore(pageDaysBefore);
    listCurrentDaysBefore = listMyBooking;

    await getDataToday(pageToday);
    listCurrentToday = listMyBooking;

    await getDataUpcoming(pageUpComing);
    listCurrentUpcoming = listMyBooking;

    await getDataCanceled(pageCanceled);
    listCurrentCanceled = listMyBooking;

    await getDataDone(pageDone);
    listCurrentDone = listMyBooking;

    isLoading = false;
    scrollDaysBefore.addListener(() => scrollListener(scrollDaysBefore),);
    scrollToday.addListener(() => scrollListener(scrollToday),);
    scrollUpComing.addListener(() => scrollListener(scrollUpComing),);
    scrollCanceled.addListener(() => scrollListener(scrollCanceled),);
    scrollDone.addListener(() => scrollListener(scrollDone),);

    notifyListeners();
  }

  Future<void> pullRefresh() async {
    await init();
    isLoadMore = false;
    notifyListeners();
  }

  Future<void> getDataDaysBefore(int page) async{
    await getMyBooking(
      MyBookingParams(
        page: page, isDaysBefore: true,
        status: Contains.confirmed,
      ),
    );
  }

  Future<void> getDataToday(int page) async{
    await getMyBooking(
      MyBookingParams(
        page: page, isToday: true,
        status: Contains.confirmed,
      ),
    );
  }

  Future<void> getDataUpcoming(int page) async{
    await getMyBooking(
      MyBookingParams(
        page: page,
        isUpcoming: true,
        status: Contains.confirmed,
      ),
    );
  }

  Future<void> getDataDone(int page) async{
    await getMyBooking(
      MyBookingParams(
        page: page,
        status: Contains.done,
      ),
    );
  }

  Future<void> getDataCanceled(int page) async{
    await getMyBooking(
      MyBookingParams(
        page: page,
        status: Contains.canceled,
      ),
    );
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
    if (currentTab==0) {
      pageDaysBefore+=1;
      await getDataDaysBefore(pageDaysBefore);
      listCurrentDaysBefore = [...listCurrentDaysBefore, ...listMyBooking];
    } else if (currentTab==1) {
      pageToday += 1;
      await getDataToday(pageToday);
      listCurrentToday = [...listCurrentToday, ...listMyBooking];
    } else if(currentTab==2){
      pageUpComing += 1;
      await getDataUpcoming(pageUpComing);
      listCurrentUpcoming = [...listCurrentUpcoming, ...listMyBooking];
    } else if(currentTab==3){
      pageDone+=1;
      await getDataDone(pageDone);
      listCurrentDone = [...listCurrentDone, ...listMyBooking];
    }else{
      pageCanceled+=1;
      await getDataCanceled(pageCanceled);
      listCurrentCanceled = [...listCurrentCanceled, ...listMyBooking];
    }
    isLoadMore = false;

    notifyListeners();
  }

  Future<void> setStatus(int value) async {
    // await pullRefresh();
    if (value == 0) {
      status = Contains.confirmed;
      currentTab=0;
    } else if (value == 1) {
      status = Contains.confirmed;
      currentTab=1;
    } else if (value == 2) {
      status = Contains.confirmed;
      currentTab=2;
    }else if (value == 3) {
      status = Contains.done;
      currentTab=3;
    } else {
      status = Contains.canceled;
      currentTab=4;
    }
    notifyListeners();
  }

  void dialogStatus({required BuildContext context, String? value, int? id}) {
    showDialogStatus(
      context: context,
      content: HistoryLanguage.cancelAppointment,
      title: HistoryLanguage.cancel,
      status: value,
      id: id,
    );
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
          rightButtonName: BookingLanguage.confirm,
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
          rightButtonName: HistoryLanguage.confirm,
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

  dynamic showSuccessDiaglog(_) async{
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
    await pullRefresh();
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

  // Future<List<MyBookingModel>> setListMyBooking({String? status, 
  //   bool isToday=false, List<MyBookingModel>? value,})async{
  //     final list=<MyBookingModel>[];
  //     if(status==Contains.confirmed && isToday==false){
  //       value!.forEach((element) {
  //         if(AppDateUtils.formatDateLocal(element.date!).split(' ')[0]
  //           != DateTime.now().toString().split(' ')[0]){
  //           list.add(element);
  //         }
  //       });
  //       return list;
  //     }
  //     return value!;
  // }

  Future<void> getMyBooking(MyBookingParams myBookingParams) 
  async {
    final result = await myBookingApi.getMyBooking(
      myBookingParams,
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
      listMyBooking= value as List<MyBookingModel>;
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
    }
    notifyListeners();
  }

  @override
  void dispose() {
    Future.delayed(const Duration(seconds: 2), () {
      timer?.cancel();
      scrollCanceled.dispose();
      scrollDaysBefore.dispose();
      scrollDone.dispose();
      scrollToday.dispose();
      scrollUpComing.dispose();
      super.dispose();
    },);
  }
}
