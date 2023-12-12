import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../resource/model/model.dart';
import '../../resource/service/my_booking.dart';
import '../../resource/service/notification_api.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class NotificationViewModel extends BaseViewModel{
  bool isLoading=true;
  bool loadingMore=false;
  bool isShowCase=true;

  NotificationApi notificationApi = NotificationApi();

  ScrollController scrollController= ScrollController();

  List<NotificationModel> listNotification=[];
  List<NotificationModel> listCurrent=[];

  int page=1;

  Timer? timer;

  GlobalKey keyNotification= GlobalKey();

  Future<void> init()async{
    page=1;
    await getNotification(page);
    listCurrent=listNotification;
    scrollController.addListener(
      scrollListener,
    );
    await AppPref.getShowCase('showCaseNotification').then(
      (value) => isShowCase=value??true,);
    startShowCase();
    await hideShowcase();
    notifyListeners();
  }

  Future<void> hideShowcase() async{
    await AppPref.setShowCase('showCaseNotification', false);
    isShowCase=false;
    notifyListeners();
  }

  void startShowCase(){
    if(isShowCase){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowCaseWidget.of(context).startShowCase(
          [keyNotification,],
        );
      });
    }
    notifyListeners();
  }

  Future<void> goToBookingDetails(BuildContext context, MyBookingParams model,) 
    => Navigator.pushNamed(context, Routers.bookingDetails, arguments: model);

  Future<void> pullRefresh() async {
    await init();
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    page += 1;
    await getNotification(page);
    listCurrent = [...listCurrent, ...listNotification];
    loadingMore = false;
    notifyListeners();
  }

  dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      loadingMore = true;
      Future.delayed(const Duration(seconds: 2), () {
        loadMoreData();
        loadingMore = false;
      });
      notifyListeners();
    }
  }

  void setColorNotification(int index){
    listNotification[index].color=AppColors.BLACK_400;
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

  void closeDialog(BuildContext context) {
    timer = Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> getNotification(int page) async {
    final result = await notificationApi.getNotification(page);

    final value = switch (result) {
      Success(value: final customer) => customer,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading = true;
    } else if (value is Exception) {
      isLoading = true;
    } else {
      listNotification = value as List<NotificationModel>;
      isLoading=false;
    }
    notifyListeners();
  }

  Future<void>  putReadNotification(int id) async {
    final result = await notificationApi.putReadNotification(id);

    final value = switch (result) {
      Success(value: final isRead) => isRead,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDialog(context);
    } else {
    }
    notifyListeners();
  }

  Future<void> readAllNotification() async {
    final result = await notificationApi.readAllNotification();

    final value = switch (result) {
      Success(value: final isRead) => isRead,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      showErrorDialog(context);
    } else {
      await pullRefresh();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    scrollController.dispose();
    super.dispose();
  }
}
