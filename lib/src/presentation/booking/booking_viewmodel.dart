// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../configs/configs.dart';
import '../../configs/widget/dialog/warnig_network_dialog.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';

import '../../resource/service/auth.dart';
import '../../resource/service/booking.dart';
import '../../resource/service/my_customer_api.dart';
import '../../resource/service/my_service_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

import '../routers.dart';

class BookingViewModel extends BaseViewModel {
  BookingApi bookingApi = BookingApi();
  List<int>? myServiceId = [];
  List<int> serviceId = [];

  List<RadioModel> selectedService = [];
  List<MyServiceModel> myService = [];
  List<MyCustomerModel> myCustumer = [];

  int? myCustomerId;

  num totalCost = 0;
  num totalPrice = 0;
  num updatedTotalCost = 0;

  DateTime dateTime = DateTime.now();

  Map<int, String> mapService = {};
  Map<int, String> mapPhone = {};

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final totalController = TextEditingController();
  final timeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final addressController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  final moneyController = TextEditingController();

  bool onAddress = true;
  bool onPhone = true;
  bool onTopic = true;
  bool onMoney = true;
  bool onTime = true;
  bool onNote = true;
  bool onDiscount = true;
  bool isListViewVisible = false;

  String? phoneErrorMsg;
  String? topicErrorMsg;
  String? moneyErrorMsg;
  String? timeErrorMsg;
  String? noteErrorMsg;
  String? discountErrorMsg;
  String? messageService;
  String searchText = '';

  final currencyFormatter =
      NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

  final phoneCheckText = RegExp(r'[a-zA-Z!@#$%^&*()]');
  final phoneCheckQuantity = RegExp(r'^(\d{0,9}|\d{11,})$');
  final specialCharsCheck = RegExp(r'[`~!@#$%^&*()"-=_+{};:\|.,/?]');
  final numberCheck = RegExp('0123456789');
  final moneyCharsCheck = RegExp(r'^\d+$');

  final onlySpecialChars = RegExp(r'^[\s,\-]*$');
  int? index;
  String? prices;
  String? services;
  bool enableButton = false;
  AuthApi authApi = AuthApi();
  MyServiceApi myServiceApi = MyServiceApi();
  MyCustomerApi myCustomerApi = MyCustomerApi();
  Future<void> init() async {
    // findPhone();
    await fetchService();
    await fetchCustomer();
    await initMapCustomer();
    await initMapService();
    notifyListeners();
  }

  // void addPercentageSymbol(String value) {
  //   if (value.isNotEmpty) {
  //     value = '$value%';
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchService() async {
    // LoadingDialog.showLoadingDialog(context);
    final result = await myServiceApi.getService();

    final value = switch (result) {
      Success(value: final accessToken) => accessToken,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      // LoadingDialog.hideLoadingDialog(context);
      // showDialogNetwork(context);
    } else if (value is Exception) {
      // LoadingDialog.hideLoadingDialog(context);
      // showOpenDialog(context);
    } else {
      // LoadingDialog.hideLoadingDialog(context);
      myService = value as List<MyServiceModel>;
    }
    notifyListeners();
  }

  Future<void> fetchCustomer() async {
    // LoadingDialog.showLoadingDialog(context);
    final result = await myCustomerApi.getMyCustomer();

    final value = switch (result) {
      Success(value: final accessToken) => accessToken,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      // LoadingDialog.hideLoadingDialog(context);
      // showDialogNetwork(context);
    } else if (value is Exception) {
      // LoadingDialog.hideLoadingDialog(context);
      // showOpenDialog(context);
    } else {
      // LoadingDialog.hideLoadingDialog(context);
      myCustumer = value as List<MyCustomerModel>;
    }
    notifyListeners();
  }

  Future<void> changeValueService(List<RadioModel> value) async {
    selectedService.clear();
    selectedService = value;

    notifyListeners();
  }

  Future<void> setServiceId() async {
    serviceId.clear();
    if (selectedService.isNotEmpty) {
      selectedService.forEach((element) {
        serviceId.add(element.id!);
      });
    }
    notifyListeners();
  }

  Future<void> removeService(int index) async {
    selectedService.removeAt(index);
    notifyListeners();
  }

  Future<void> initMapCustomer() async {
    myCustumer.forEach((element) {
      mapPhone.addAll(
        {element.id!: '0${element.phoneNumber}'},
      );
    });
    notifyListeners();
  }

  Future<void> initMapService() async {
    myService.forEach((element) {
      mapService.addAll(
        {
          element.id!:
              ' ${element.name}/${currencyFormatter.format(element.money)} '
        },
      );
    });
    notifyListeners();
  }

  Future<void> setNameCustomer(MapEntry<dynamic, dynamic> value) async {
    phoneController.text = value.value;
    nameController.text = myCustumer
        .where((element) => element.id == value.key)
        .first
        .fullName
        .toString();
    myCustomerId = value.key;

    notifyListeners();
  }

  Future<void> clearTotal() async {
    updatedTotalCost = 0;
    totalCost = 0;
    totalController.clear();
    notifyListeners();
  }

  Future<void> calculateTotalPriceByName({bool isCalculate = false}) async {
    await clearTotal();
    myService.forEach((element) {
      serviceId.forEach((elementId) {
        if (element.id == elementId) {
          updatedTotalCost += element.money!;
        }
      });
      totalCost = updatedTotalCost;
      final totalPriceT = currencyFormatter.format(totalCost);
      totalController.text = totalPriceT;
      moneyController.text = totalPriceT;
    });
    totalDiscount();
    notifyListeners();
  }

  void totalDiscount() {
    final moneyText = discountController.text;
    final moneyInt = moneyText != '' ? double.parse(moneyText) : 0;

    final totalCostDiscount = totalCost - (totalCost * (moneyInt / 100));

    final totalPriceT = currencyFormatter.format(totalCostDiscount);

    totalController.text = totalPriceT;

    notifyListeners();
  }

  void dis() {
    phoneController.dispose();
  }

  Future<void> updateDate() async {
    final date = await pickDate();
    if (date == null) {
      return;
    }
    if (date != dateTime) {
      dateTime = date;
    }
    final newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      dateTime.hour,
      dateTime.minute,
    );
    dateTime = newDateTime;
    notifyListeners();
  }

  Future<void> updateTime() async {
    final time = await pickTime();
    if (time == null) {
      return;
    }
    final now = DateTime.now();
    final newDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      time.hour,
      time.minute,
    );
    if (newDateTime.isBefore(now)) {
      print('loi loi');
      return;
    }
    dateTime = newDateTime;
    notifyListeners();
  }

  void checkNoteInput() {
    if (noteController.text.isEmpty) {
      onNote = false;
      noteErrorMsg = ServiceAddLanguage.emptyDescriptionError;
    } else {
      noteErrorMsg = '';
      onNote = true;
    }
    notifyListeners();
  }

  void checkDiscountInput(String value) {
    final number = double.tryParse(value);

    if (value.isEmpty) {
      discountErrorMsg = '';
    } else if (onlySpecialChars.hasMatch(value)) {
      discountErrorMsg = BookingLanguage.onlySpecialChars;
    } else if (number == null || number < 0 || number > 100) {
      discountErrorMsg = BookingLanguage.numberBetween;
    } else {
      discountErrorMsg = '';
    }
    notifyListeners();
  }

  void enableConfirmButton() {
    if (onPhone &&
        onAddress &&
        selectedService.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      enableButton = true;
    } else {
      enableButton = false;
    }
    notifyListeners();
  }

  void confirmButton() {
    if (enableButton) {}
    notifyListeners();
  }

  Future<void> onServiceList(BuildContext context) =>
      Navigator.pushNamed(context, Routers.serviceList);

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
  Future<void> goToHome() => Navigator.pushNamed(
        context,
        Routers.home,
      );

  dynamic showOpenDialog(_) {
    showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          content: BookingLanguage.bookingSuccessful,
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
          leftButtonName: SignUpLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: BookingLanguage.home,
          onTapLeft: () {
            clearData();
            Navigator.pop(context);
          },
          onTapRight: () {
            goToHome();
          },
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

  void clearData() {
    selectedService.clear();
    totalController.clear();
    phoneController.text = '';
    discountController.text = '';
    nameController.clear();
    addressController.clear();
    noteController.clear();
    notifyListeners();
  }

  Future<void> postBooking() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await bookingApi.postBooking(MyBookingPramsApi(
      myCustomerId: myCustomerId,
      myServices: serviceId,
      address: addressController.text.trim(),
      date: dateTime.toString().trim(),
      discount: double.parse(
          discountController.text.isEmpty ? '0' : discountController.text),
      note: noteController.text == '' ? 'Trống' : noteController.text,
    ));

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
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

      await showOpenDialog(context);
    }
    notifyListeners();
  }
}
