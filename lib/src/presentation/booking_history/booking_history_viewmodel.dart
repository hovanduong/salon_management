// ignore_for_file: avoid_bool_literals_in_conditional_expressions, avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/my_booking_model.dart';
import '../../resource/service/my_booking.dart';
import '../../resource/service/notification_api.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../../utils/date_format_utils.dart';
import '../../configs/firebase/notification_firebase/permission_notification.dart';
import '../base/base.dart';
import '../routers.dart';

class Contains {
  static const confirmed = 'Confirmed';
  static const canceled = 'Canceled';
  static const done = 'Done';
}

class BookingHistoryViewModel extends BaseViewModel {
  MyBookingApi myBookingApi = MyBookingApi();
  NotificationApi notificationApi= NotificationApi();

  ScrollController scrollUpComing = ScrollController();
  ScrollController scrollDone = ScrollController();
  ScrollController scrollCanceled = ScrollController();
  ScrollController scrollToday = ScrollController();
  ScrollController scrollDaysBefore = ScrollController();

  List<MyBookingModel> listMyBooking = [];
  List<MyBookingModel> listCurrentUpcoming = [];
  List<MyBookingModel> listCurrentToday = [];
  List<MyBookingModel> listCurrentDone = [];
  List<MyBookingModel> listCurrentCanceled = [];
  List<MyBookingModel> listCurrentDaysBefore = [];

  bool isLoadMore = false;
  bool isLoading = true;
  bool isToday = true;
  bool isPullRefresh = false;
  bool isShowCase=false;
  bool isShowCaseRemind=false;
  bool isRemind=false;

  int pageUpComing = 1;
  int pageDone = 1;
  int pageCanceled = 1;
  int pageToday = 1;
  int pageDaysBefore = 1;
  int currentTab = 1;

  GlobalKey addBooking = GlobalKey();
  GlobalKey keyNotification = GlobalKey();
  GlobalKey keyRemind1 = GlobalKey();
  GlobalKey keyRemind2= GlobalKey();
  GlobalKey keyStatus1= GlobalKey();
  GlobalKey keyStatus2 = GlobalKey();
  GlobalKey keyED1 = GlobalKey();
  GlobalKey keyED2 = GlobalKey();

  Timer? timer;

  String status = Contains.confirmed;

  TabController? tabController;

  String? idNotification;

  Future<void> init({dynamic dataThis}) async {
    await setId();
    await fetchData();
    await AppPref.getShowCase('showCaseAppointment').then(
      (value) =>isShowCase=value??true,);
    await startShowCase();
    await hideShowcase();
    tabController=TabController(length: 5, vsync: dataThis, initialIndex: 1);
    notifyListeners();
  }

  Future<void> setId()async{
    idNotification= await AppPref.getDataUSer('id') ?? '0';
    notifyListeners();
  }

  Future<void> hideShowcase() async{
    if(isShowCase){
      await AppPref.setShowCase('showCaseAppointment', false);
      isShowCase=false;
    }
    if(listCurrentToday.isNotEmpty || 
      (listCurrentUpcoming.isNotEmpty && currentTab==2)){
      await AppPref.setShowCase('showCaseRemind', false);
      isShowCaseRemind=false;
    }
    notifyListeners();
  }

  Future<void> startShowCase()async{
    if(isShowCase){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowCaseWidget.of(context).startShowCase(
          [addBooking, keyNotification,keyRemind1, keyStatus1, keyED1],
        );
      });
    }
    if(isShowCaseRemind){
      if(listCurrentUpcoming.isNotEmpty && currentTab==2){
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ShowCaseWidget.of(context).startShowCase(
            [keyRemind2, keyStatus2, keyED2],
          );
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ShowCaseWidget.of(context).startShowCase(
            [keyRemind1, keyStatus1, keyED1,addBooking, keyNotification,],
          );
        });
      }
    }
    
  }

  Future<void> goToAddBooking({
    required BuildContext context,
    MyBookingModel? myBookingModel,
  }) async {
    await Navigator.pushNamed(
      context,
      Routers.addBooking,
      arguments: myBookingModel,
    );
    await fetchData();
  }

  Future<void> goToBookingDetails(
          BuildContext context, MyBookingParams model,) =>
      Navigator.pushNamed(context, Routers.bookingDetails, arguments: model);
  
  Future<void> goToNotification(BuildContext context,) 
    => Navigator.pushNamed(context, Routers.notification,);

  Future<void> fetchData() async {
    await getData();
    isPullRefresh=false;
    isLoading=false;
    await AppPref.getShowCase('showCaseRemind').then(
      (value) => isShowCaseRemind=value??true,);
    await startShowCase();
    await hideShowcase();
    notifyListeners();
  }

  Future<void> getData() async{
    isLoading=true;
    if(currentTab==1){
      await getDataToday(pageToday);
      listCurrentToday = listMyBooking;
      scrollToday.addListener(
        () => scrollListener(scrollToday),
      );
    }else if(currentTab==0){
      await getDataDaysBefore(pageDaysBefore);
      listCurrentDaysBefore = listMyBooking;
      scrollDaysBefore.addListener(
        () => scrollListener(scrollDaysBefore),
      );
    }else if(currentTab==2){
      await getDataUpcoming(pageUpComing);
      listCurrentUpcoming = listMyBooking;
      scrollUpComing.addListener(
        () => scrollListener(scrollUpComing),
      );
    }else if(currentTab==3){
      await getDataDone(pageDone);
      listCurrentDone = listMyBooking;
      scrollDone.addListener(
        () => scrollListener(scrollDone),
      );
    }else {
      await getDataCanceled(pageCanceled);
      listCurrentCanceled = listMyBooking;
      scrollCanceled.addListener(
        () => scrollListener(scrollCanceled),
      );
    }
    notifyListeners();
  }

  Future<void> pullRefresh() async {
    if(currentTab==1){
      pageDaysBefore = 1;
    }else if(currentTab==0){
      pageToday=1;
    }else if(currentTab==2){
      pageUpComing=1;
    }else if(currentTab==3){
      pageDone = 1;
    }else {
      pageCanceled = 1;
    }
    isPullRefresh=true;
    isLoading=true;
    notifyListeners();
    await fetchData();
    isLoadMore = false;
    notifyListeners();
  }

  Future<void> getDataDaysBefore(int page) async {
    await getMyBooking(
      MyBookingParams(
        page: page,
        isDaysBefore: true,
        status: Contains.confirmed,
      ),
    );
  }

  Future<void> getDataToday(int page) async {
    await getMyBooking(
      MyBookingParams(
        page: page,
        isToday: true,
        status: Contains.confirmed,
      ),
    );
  }

  Future<void> getDataUpcoming(int page) async {
    await getMyBooking(
      MyBookingParams(
        page: page,
        isUpcoming: true,
        status: Contains.confirmed,
      ),
    );
  }

  Future<void> getDataDone(int page) async {
    await getMyBooking(
      MyBookingParams(
        page: page,
        status: Contains.done,
      ),
    );
  }

  Future<void> getDataCanceled(int page) async {
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
    isLoading=true;
    if (currentTab == 0) {
      pageDaysBefore += 1;
      await getDataDaysBefore(pageDaysBefore);
      listCurrentDaysBefore = [...listCurrentDaysBefore, ...listMyBooking];
    } else if (currentTab == 1) {
      pageToday += 1;
      await getDataToday(pageToday);
      listCurrentToday = [...listCurrentToday, ...listMyBooking];
    } else if (currentTab == 2) {
      pageUpComing += 1;
      await getDataUpcoming(pageUpComing);
      listCurrentUpcoming = [...listCurrentUpcoming, ...listMyBooking];
    } else if (currentTab == 3) {
      pageDone += 1;
      await getDataDone(pageDone);
      listCurrentDone = [...listCurrentDone, ...listMyBooking];
    } else {
      pageCanceled += 1;
      await getDataCanceled(pageCanceled);
      listCurrentCanceled = [...listCurrentCanceled, ...listMyBooking];
    }
    isLoadMore=false;
    isLoading=false;
    notifyListeners();
  }

  Future<void> setStatus(int value) async {
    if (value == 0) {
      status = Contains.confirmed;
      currentTab = 0;
    } else if (value == 1) {
      status = Contains.confirmed;
      currentTab = 1;
    } else if (value == 2) {
      status = Contains.confirmed;
      currentTab = 2;
      await AppPref.getShowCase('showCaseRemind').then(
      (value) => isShowCaseRemind=value??true,);
      await startShowCase();
      await hideShowcase();
    } else if (value == 3) {
      status = Contains.done;
      currentTab = 3;
    } else {
      status = Contains.canceled;
      currentTab = 4;
    }
    await getData();
    notifyListeners();
  }

  void dialogStatus({required BuildContext context, String? value, int? id}) {
    if(value == Contains.confirmed){
      showDialogStatus(
        context: context,
        content: HistoryLanguage.confirmAppointment,
        title: HistoryLanguage.confirm,
        status: value,
        id: id,
      );
    }else if(value==Contains.done){
      showDialogStatus(
        context: context,
        content: HistoryLanguage.appointmentEnd,
        title: HistoryLanguage.done,
        status: value,
        id: id,
      );
    }else{
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

  void copyPhone(String phone){
    Clipboard.setData(ClipboardData(text: phone)).then((_){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Paragraph(
            content: BookingLanguage.contentCopyPhone,
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),),);
    });
  }

  dynamic showWaningDiaglog(int id) {
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
          onTapRight: () async{
            Navigator.pop(context);
            await getCancelRemind(NotificationParams(
              idBooking: id, isRemind: false,
            ),);
            await deleteBookingHistory(id);
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

  void closeDialog(BuildContext context) {
    timer = Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  dynamic showSuccessDiaglog(_) async {
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

  Future<void> checkAllowNotification(bool value, MyBookingModel list) async{
    final isAllow= await AppPermNotification.checkPermission(
      Permission.notification, context,);
    if(isAllow==true){
      await setRemind(value, list);
    }else{
      await AppPermNotification.showDialogSettings(context);
    }
    notifyListeners();
  }

  Future<void> setRemind(bool value, MyBookingModel list)async{
    isRemind=value;
    if(value){
      await postRemindNotification(NotificationParams(
        idBooking: list.id,
        date: AppDateUtils.splitHourDate(
          AppDateUtils.formatDateLocal(list.date??''),
        ),
        nameCustomer: list.myCustomer?.fullName!=''? list.myCustomer?.fullName
          :null,
        address: list.address!=''? list.address : null,
        isRemind: value,
        bookingCode: list.code,
      ),);
    }else{
      await getCancelRemind(NotificationParams(
        idBooking: list.id,
        isRemind: value,
      ),);
    }
    notifyListeners();
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

  Future<void> getMyBooking(MyBookingParams myBookingParams) async {
    notifyListeners();
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
      listMyBooking = value as List<MyBookingModel>;
      isLoading=false;
    }
    notifyListeners();
  }

  Future<void> postRemindNotification(NotificationParams params) async {
    // LoadingDialog.showLoadingDialog(context);
    final result = await notificationApi.postRemindNotification(params);

    final value = switch (result) {
      Success(value: final bool) => bool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      // LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      // LoadingDialog.hideLoadingDialog(context);
      await putRemindBooking(params.idBooking??0, params.isRemind);
    }
    notifyListeners();
  }

  Future<void> getCancelRemind(NotificationParams params) async {
    // LoadingDialog.showLoadingDialog(context);
    final result = await notificationApi.getCancelRemind(params.idBooking??0);

    final value = switch (result) {
      Success(value: final bool) => bool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      // LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      // LoadingDialog.hideLoadingDialog(context);
      await putRemindBooking(params.idBooking??0, params.isRemind);
    }
    notifyListeners();
  }

  Future<void> putRemindBooking(int id, bool isRemind) async {
    // LoadingDialog.showLoadingDialog(context);
    final result = await myBookingApi.putRemindBooking(
      MyBookingParams(
        id: id,
        isRemind: isRemind,
      ),
    );

    final value = switch (result) {
      Success(value: final bool) => bool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      // LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      // LoadingDialog.hideLoadingDialog(context);
      // showSuccessDiaglog(context);
      await fetchData();
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
    Future.delayed(
      const Duration(seconds: 2),
      () {
        timer?.cancel();
        tabController?.dispose();
        scrollCanceled.dispose();
        scrollDaysBefore.dispose();
        scrollDone.dispose();
        scrollToday.dispose();
        scrollUpComing.dispose();
        super.dispose();
      },
    );
  }
}
