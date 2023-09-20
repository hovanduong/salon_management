import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/configs.dart';
import '../../resource/model/my_booking_model.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/my_booking.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class HistoryBookingViewModel extends BaseViewModel {
  bool isSwitch = false;
  MyBookingApi myBookingApi = MyBookingApi();
  ScrollController scrollController = ScrollController();
  List<MyBookingModel> listMyBooking = [];
  List<MyBookingModel> listCurrent = [];
  bool isLoadMore = false;
  int page = 1;

  Future<void> init() async {
    listCurrent.clear();
    page = 1;
    await getMyBooking(1);
    listCurrent = listMyBooking;
    scrollController.addListener(scrollListener);
    notifyListeners();
  }

  Future<void> pullRefresh() async {
    await init();
    isLoadMore = false;
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    page += 1;
    await getMyBooking(page);

    listCurrent = [...listCurrent, ...listMyBooking];
    isLoadMore = false;

    notifyListeners();
  }

  dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      isLoadMore = true;
      Future.delayed(const Duration(seconds: 2), loadMoreData);
      notifyListeners();
    }
  }

  void setIsSwitch() {
    isSwitch = !isSwitch;
    notifyListeners();
  }

  Future<void> sendPhone(String phoneNumber, String scheme) async {
    print(phoneNumber);
    final launchUri = Uri(
      scheme: scheme,
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  dynamic showDialogNetwork(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          content: CreatePasswordLanguage.errorNetwork,
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
          buttonName: SignUpLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          onTap: () => Navigator.pop(context),
        );
      },
    );
  }

  dynamic showErrorDialog(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
        );
      },
    );
  }

  Future<void> getMyBooking(int page) async {
    final result =
        await myBookingApi.getMyBooking(AuthParams(page: page, pageSize: 10));
    print(page);

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
}
