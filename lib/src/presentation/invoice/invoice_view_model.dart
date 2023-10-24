import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/invoice_model.dart';
import '../../resource/service/invoice.dart';
import '../../resource/service/my_booking.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class InvoiceViewModel extends BaseViewModel {
  InvoiceApi invoiceApi = InvoiceApi();

  List colors = [
    AppColors.COLOR_TEAL,
    AppColors.COLOR_OLIVE,
    AppColors.COLOR_MAROON,
    AppColors.COLOR_GREEN_LIST,
    AppColors.COLOR_PURPLE,
    AppColors.PRIMARY_PINK,
  ];

  List<InvoiceModel> listInvoice = [];
  List<InvoiceModel> listFoundInvoice = [];
  List<InvoiceModel> listCurrent = [];

  ScrollController scrollController = ScrollController();

  bool isLoading = true;
  bool loadingMore = false;

  int page = 1;

  Timer? _timer;

  Future<void> init() async {
    _startDelay();
  }

  Timer _startDelay() =>
      _timer = Timer(const Duration(milliseconds: 1000), fetchData);

  Future<void> fetchData() async {
    page = 1;
    await getInvoice(page);
    scrollController.addListener(scrollListener);
    listCurrent = listInvoice;
    listFoundInvoice = listInvoice;
    notifyListeners();
  }

  Future<void> goToBookingDetails(
          BuildContext context, MyBookingParams params) =>
      Navigator.pushNamed(context, Routers.bookingDetails, arguments: params);

  Future<void> goToAddInvoice(BuildContext context) =>
      Navigator.pushNamed(context, Routers.payment);

  Future<void> pullRefresh() async {
    await init();
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    page += 1;
    await getInvoice(page);
    listCurrent = [...listCurrent, ...listInvoice];
    listFoundInvoice = listCurrent;
    loadingMore = false;
    notifyListeners();
  }

  dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      loadingMore = true;
      Future.delayed(const Duration(seconds: 2), loadMoreData);

      notifyListeners();
    }
  }

  Future<void> filterCategory(String searchCategory) async {
    var listSearchCategory = <InvoiceModel>[];
    listSearchCategory = listInvoice
        .where(
          (element) =>
              element.code!.toLowerCase().contains(searchCategory) ||
              element.myBooking!.myCustomer!.fullName!
                  .toLowerCase()
                  .contains(searchCategory),
        )
        .toList();
    listFoundInvoice = listSearchCategory;
    notifyListeners();
  }

  Future<void> onSearchCategory(String value) async {
    if (value.isEmpty) {
      listFoundInvoice = listInvoice;
    } else {
      final searchCategory = value.toLowerCase();
      await filterCategory(searchCategory);
    }
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

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  Future<void> getInvoice(int page) async {
    final result = await invoiceApi.getInvoice(
      InvoiceParams(
        page: page,
      ),
    );

    final value = switch (result) {
      Success(value: final isBool) => isBool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading = true;
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      listInvoice = value as List<InvoiceModel>;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteInvoice(int id) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await invoiceApi.deleteInvoice(id);

    final value = switch (result) {
      Success(value: final isBool) => isBool,
      Failure(exception: final exception) => exception,
    };
    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      await showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      await showErrorDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      await showSuccessDiaglog(context);
      await fetchData();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
