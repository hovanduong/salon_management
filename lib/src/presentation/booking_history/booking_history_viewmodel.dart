import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/configs.dart';
import '../../configs/widget/dialog/warnig_network_dialog.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/my_booking_model.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/my_booking.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class BookingHistoryViewModel extends BaseViewModel {
  MyBookingApi myBookingApi = MyBookingApi();

  ScrollController scrollController = ScrollController();

  List<MyBookingModel> listMyBooking = [];
  List<MyBookingModel> listCurrentUpcoming = [];
  List<MyBookingModel> listCurrentDone = [];
  List<MyBookingModel> listCurrentCanceled = [];

  bool isSwitch = false;
  bool isLoadMore = false;
  bool isLoading = true;

  int pageUpComing = 1;
  int pageDone = 1;
  int pageCanceled = 1;

  String status = 'Confirmed';

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

  Future<void> goToBookingDetails(BuildContext context, int id) =>
      Navigator.pushNamed(context, Routers.bookingDetails, arguments: id);

  Future<void> fetchData() async {
    listCurrentUpcoming.clear();
    pageUpComing = 1;
    pageDone = 1;
    pageCanceled = 1;

    await getMyBooking(pageUpComing, 'Confirmed');
    listCurrentUpcoming = listMyBooking;

    await getMyBooking(pageCanceled, 'Canceled');
    listCurrentCanceled = listMyBooking;

    await getMyBooking(pageDone, 'Done');
    listCurrentDone = listMyBooking;

    isLoading = false;
    scrollController.addListener(scrollListener);

    notifyListeners();
  }

  Future<void> pullRefresh() async {
    await init();
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

  Future<void> loadMoreData() async {
    if (status == 'Confirmed') {
      pageUpComing += 1;
      await getMyBooking(pageUpComing, status);
      listCurrentUpcoming = [...listCurrentUpcoming, ...listMyBooking];
    } else if (status == 'Canceled') {
      pageCanceled += 1;
      await getMyBooking(pageCanceled, status);
      listCurrentCanceled = [...listCurrentCanceled, ...listMyBooking];
    } else {
      pageDone += 1;
      await getMyBooking(pageDone, status);
      listCurrentDone = [...listCurrentDone, ...listMyBooking];
    }
    isLoadMore = false;

    notifyListeners();
  }

  Future<void> setStatus(int value) async {
    await pullRefresh();
    if (value == 0) {
      status = 'Confirmed';
    } else if (value == 1) {
      status = 'Done';
    } else {
      status = 'Canceled';
    }
    notifyListeners();
  }

  void dialogStatus({required BuildContext context, String? value, int? id}) {
    if (value!.contains('Confirmed')) {
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

  dynamic showSuccessDiaglog(_) {
    showDialog(
      context: context,
      builder: (context) {
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
      builder: (context) {
        return WarningOneDialog(
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
        );
      },
    );
  }

  Future<void> getMyBooking(int page, String status) async {
    final result = await myBookingApi.getMyBooking(
      AuthParams(
        page: page,
        status: status,
      ),
    );

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

  Future<void> putStatusAppointment(int id, String status) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await myBookingApi.putStatusAppointment(
      AuthParams(
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

  Future<void> deleteBookingHistory(int id) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await myBookingApi.deleteBookingHistory(
      AuthParams(
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
}
