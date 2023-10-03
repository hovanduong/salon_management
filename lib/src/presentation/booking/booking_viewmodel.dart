// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../configs/configs.dart';
import '../../configs/widget/dialog/warnig_network_dialog.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';

import '../../resource/model/my_booking_model.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/booking.dart';
import '../../resource/service/my_customer_api.dart';
import '../../resource/service/my_service_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

import '../routers.dart';

class BookingViewModel extends BaseViewModel {
  BookingApi bookingApi = BookingApi();
  MyServiceApi myServiceApi = MyServiceApi();
  MyCustomerApi myCustomerApi = MyCustomerApi();
  AuthApi authApi = AuthApi();

  List<int>? myServiceId = [];
  List<int> serviceId = [];

  List<RadioModel> selectedService = [];
  List<MyServiceModel> myService = [];
  List<MyCustomerModel> myCustomer = [];

  int? myCustomerId;
  int? index;

  num totalCost = 0;
  num totalPrice = 0;
  num updatedTotalCost = 0;

  DateTime dateTime = DateTime.now();

  MyBookingModel? dataMyBooking;

  Map<int, String> mapService = {};
  Map<int, String> mapPhone = {};

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final totalController = TextEditingController();
  final timeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController moneyController = TextEditingController();

  DateRangePickerController dateController = DateRangePickerController();

  bool onAddress = true;
  bool onPhone = true;
  bool onTopic = true;
  bool onMoney = true;
  bool onTime = true;
  bool onNote = true;
  bool onDiscount = true;
  bool isListViewVisible = false;
  bool enableButton = false;

  String? phoneErrorMsg;
  String? topicErrorMsg;
  String? moneyErrorMsg;
  String? timeErrorMsg;
  String? noteErrorMsg;
  String? addressMsg;
  String? discountErrorMsg;
  String? messageService;
  String searchText = '';
  String? prices;
  String? services;

  final currencyFormatter =
      NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

  final phoneCheckText = RegExp(r'[a-zA-Z!@#$%^&*()]');
  final phoneCheckQuantity = RegExp(r'^(\d{0,9}|\d{11,})$');
  final specialCharsCheck = RegExp(r'[`~!@#$%^&*()"-=_+{};:\|.,/?]');
  final numberCheck = RegExp('0123456789');
  final moneyCharsCheck = RegExp(r'^\d+$');
  final onlySpecialChars = RegExp(r'^[\s,\-]*$');

  Future<void> init(MyBookingModel? myBookingModel) async {
    await setDataMyBooking(myBookingModel);
    await fetchService();
    await fetchCustomer();
    await initMapCustomer();
    await initMapService();
    notifyListeners();
  }

  Future<void> setDataMyBooking(MyBookingModel? myBookingModel) async {
    if (myBookingModel != null) {
      dataMyBooking = myBookingModel;
      phoneController.text = dataMyBooking!.myCustomer!.phoneNumber!;
      nameController.text = dataMyBooking!.myCustomer!.fullName!;
      addressController.text = dataMyBooking!.address!;
      noteController.text =
          dataMyBooking!.note != 'Trống' ? dataMyBooking!.note! : '';
      setSelectedService();
      await setServiceId();
      await fetchService();
      await calculateTotalPriceByName();
      enableConfirmButton();
    }
    notifyListeners();
  }

  void setSelectedService() {
    if (dataMyBooking!.myServices!.isNotEmpty) {
      dataMyBooking?.myServices!.forEach((service) {
        selectedService.add(RadioModel(
          isSelected: true,
          id: service.id,
          name: '${service.name}/${currencyFormatter.format(service.money)}',
        ),);
      });
    }
  }

  Future<void> fetchService() async {
    final result = await myServiceApi.getService();

    final value = switch (result) {
      Success(value: final accessToken) => accessToken,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
    } else if (value is Exception) {
    } else {
      myService = value as List<MyServiceModel>;
    }
    notifyListeners();
  }

  Future<void> fetchCustomer() async {
    final result = await myCustomerApi.getMyCustomer(getAll: true);

    final value = switch (result) {
      Success(value: final accessToken) => accessToken,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
    } else if (value is Exception) {
    } else {
      myCustomer = value as List<MyCustomerModel>;
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
    myCustomer.forEach((element) {
      mapPhone.addAll(
        {element.id!: '${element.phoneNumber}'},
      );
    });
    notifyListeners();
  }

  Future<void> initMapService() async {
    myService.forEach((element) {
      mapService.addAll(
        {
          element.id!:
              ' ${element.name}/${currencyFormatter.format(element.money)} ',
        },
      );
    });
    notifyListeners();
  }

  Future<void> setNameCustomer(MapEntry<dynamic, dynamic> value) async {
    phoneController.text = value.value;
    nameController.text = myCustomer
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

  Future<void> updateDateTime(DateTime time) async {
    dateTime = time;
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

  void validAddress(String value) {
    if (addressController.text.isEmpty) {
      addressMsg = BookingLanguage.emptyAddress;
    } else {
      addressMsg = '';
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

  Future<void> goToHome() => Navigator.pushReplacementNamed(
        context,
        Routers.home,
      );

  dynamic showDialogSuccess(_) {
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

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  void clearData() {
    serviceId.clear();
    selectedService.clear();
    totalController.clear();
    phoneController.text = '';
    discountController.text = '';
    moneyController.text = '';
    nameController.text = '';
    addressController.clear();
    noteController.clear();
    notifyListeners();
  }

  Future<void> postBooking() async {
    log('message $dateTime');
    final result = await bookingApi.postBooking(MyBookingPramsApi(
      myCustomerId: myCustomerId,
      myServices: serviceId,
      address: addressController.text.trim(),
      date: dateTime.toString().trim(),
      isBooking: true,
      note: noteController.text == '' ? 'Trống' : noteController.text,
    ),);

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
      clearData();
      await showDialogSuccess(context);
    }
    notifyListeners();
  }

  Future<void> putBooking() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await bookingApi.putBooking(MyBookingPramsApi(
      id: dataMyBooking!.id,
      myServices: serviceId,
      address: addressController.text.trim(),
      date: dateTime.toString().trim(),
      discount: double.parse(
          discountController.text.isEmpty ? '0' : discountController.text,),
      note: noteController.text == '' ? 'Trống' : noteController.text,
    ),);

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
      await showDialogSuccess(context);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
