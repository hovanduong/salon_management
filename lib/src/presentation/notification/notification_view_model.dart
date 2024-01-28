import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/firebase/notification_firebase/app_barge.dart';
import '../../resource/model/model.dart';
import '../../resource/service/my_booking.dart';
import '../../resource/service/notification_api.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class NotificationViewModel extends BaseViewModel {
  bool isLoading = true;
  bool loadingMore = false;
  bool isShowCase = true;

  NotificationApi notificationApi = NotificationApi();

  ScrollController scrollController = ScrollController();

  List<NotificationModel> listNotification = [];
  List<NotificationModel> listCurrent = [];

  int page = 1;
  int ? idUser;

  Timer? timer;

  GlobalKey keyNotification = GlobalKey();

  Future<void> init() async {
    idUser = int.parse(await AppPref.getDataUSer('id') ?? '0');
    page = 1;
    await getNotification(page);
    listCurrent = listNotification;
    scrollController.addListener(
      scrollListener,
    );
    await AppPref.getShowCase('showCaseNotification$idUser').then(
      (value) => isShowCase = value ?? true,
    );
    startShowCase();
    await hideShowcase();
    notifyListeners();
  }

  Future<void> hideShowcase() async {
    await AppPref.setShowCase('showCaseNotification$idUser', false);
    isShowCase = false;
    notifyListeners();
  }

  void startShowCase() {
    if (isShowCase) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowCaseWidget.of(context).startShowCase(
          [
            keyNotification,
          ],
        );
      });
    }
    notifyListeners();
  }

  Future<void> goToBookingDetails(
    BuildContext context,
    MyBookingParams model,
  ) async {
    await Navigator.pushNamed(
      context,
      Routers.bookingDetails,
      arguments: model,
    );
  }

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

  // dynamic scrollListener() async {
  //   if (scrollController.position.pixels ==
  //           scrollController.position.maxScrollExtent &&
  //       scrollController.position.pixels > 0) {
  //     loadingMore = true;
  //     Future.delayed(const Duration(seconds: 2), () {
  //       loadMoreData();
  //       loadingMore = false;
  //     });
  //     notifyListeners();
  //   }
  // }

  void scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      print(scrollController.position.pixels);
      if (!loadingMore) {
        loadingMore = true;
        notifyListeners();
        Future.delayed(const Duration(seconds: 2), () {
          loadMoreData();
          loadingMore = false;
          notifyListeners();
        });
      }
    }
    notifyListeners();
  }

  void setColorNotification(int index) {
    listNotification[index].color = AppColors.BLACK_400;
    notifyListeners();
  }

  dynamic showDialogSeeAllNotification(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          content: BookingLanguage.readAllNotification,
          image: AppImages.icPlus,
          title: SignUpLanguage.notification,
          leftButtonName: SignUpLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: BookingLanguage.confirm,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () async {
            await AppBarge.addBarge();
            Navigator.pop(context);
            await readAllNotification();
          },
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

  Future<void> readAndShowDetailBooking(int index) async {
    final id = listCurrent[index].metaData?.appointmentId;
    if (listCurrent[index].isRead == false && id != null) {
      await putReadNotification(
        NotificationParams(
          id: listCurrent[index].id ?? 0,
          type: listCurrent[index].type,
        ),
      );
    }
    await AppBarge.addBarge();
    if (listCurrent[index].type == 'reminder' && id != null) {
      await goToBookingDetails(
        context,
        MyBookingParams(
          id: id,
        ),
      );
      await pullRefresh();
    }
    notifyListeners();
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
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> putReadNotification(NotificationParams params) async {
    final result = await notificationApi.putReadNotification(params);

    final value = switch (result) {
      Success(value: final isRead) => isRead,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      // showErrorDialog(context);
    } else {}
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
