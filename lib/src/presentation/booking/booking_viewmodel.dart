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
  final List<Widget> fields = [];
  String? messageService;
  List<int>? myServiceId = [];
  int? myCustomerId;
  BookingApi bookingApi = BookingApi();
  // late Object dropValue = myService.first;

  String searchText = '';
  DateTime dateTime = DateTime.now();

  // List<String>? selectedServices = [];
  Map<int, String> mapService = {};

  List<int> serviceId = [];
  num totalCost = 0;
  List<MyCustomerModel> searchResults = [];
  List<RadioModel> selectedService = [];
  bool isListViewVisible = false;
  Map<int, String> mapPhone = {};
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final totalController = TextEditingController();
  final timeController = TextEditingController();
  final noteController = TextEditingController();
  final addressController = TextEditingController();
  final discountController = TextEditingController();

  bool onAddress = true;
  bool onPhone = true;
  bool onTopic = true;
  bool onMoney = true;
  bool onTime = true;
  bool onNote = true;
  bool onDiscount = true;

  String? phoneErrorMsg;
  String? topicErrorMsg;
  String? moneyErrorMsg;
  String? timeErrorMsg;
  String? noteErrorMsg;
  String? discountErrorMsg;

  List<MyServiceModel> myService = [];
  List<MyCustomerModel> myCustumer = [];

  final currencyFormatter =
      NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

  final phoneCheckText = RegExp(r'[a-zA-Z!@#$%^&*()]');
  final phoneCheckQuantity = RegExp(r'^(\d{0,9}|\d{11,})$');
  final specialCharsCheck = RegExp(r'[`~!@#$%^&*()"-=_+{};:\|.,/?]');
  final numberCheck = RegExp('0123456789');
  final moneyCharsCheck = RegExp(r'^\d+$');

  final discountCheck = RegExp(r'^(?!0*(?:100|\d{1,2})$)\d+$');

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
    totalCost = 0;
    if (selectedService.isNotEmpty) {
      selectedService.forEach((element) {
        serviceId.add(element.id!);
      });
    }
    print(totalCostDiscount);
    print(serviceId);
    notifyListeners();
  }

  void removeService(int index) {
    selectedService.removeAt(index);

    notifyListeners();
  }

  Future<void> initMapCustomer() async {
    myCustumer.forEach((element) {
      mapPhone.addAll(
        {element.id!: '${element.phoneNumber}'},
      );
    });
    print(mapPhone);
    notifyListeners();
  }

  Future<void> initMapService() async {
    myService.forEach((element) {
      mapService.addAll(
        {element.id!: '${element.name}'},
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

  num totalPrice = 0;
  // void calculateTotalPrice() {

  //   totalPrice = calculateTotalPriceByName(myService, serviceId);

  //   totalController.text = totalPriceT;
  //   notifyListeners();
  // }
  num totalCostDiscount = 0;
  num updatedTotalCost = 0;
  void calculateTotalPriceByName() {
    myService.forEach((element) {
      serviceId.forEach((elementId) {
        if (element.id == elementId) {
          updatedTotalCost += element.money!;
        }
      });
      totalCost = updatedTotalCost;
      final totalPriceT = currencyFormatter.format(totalCost);
      totalController.text = totalPriceT;
    });

    // print(moneyInt);
    print(totalCost);
    notifyListeners();
  }

  void totalDiscount() {
    final moneyText = discountController.text;

    final moneyInt = moneyText != '' ? int.parse(moneyText) : 0;
    totalCostDiscount = totalCost - (totalCost * moneyInt / 100);
    final totalPriceT = currencyFormatter.format(totalCostDiscount);
    totalController.text = totalPriceT;
    print(totalCost);
    print(totalCostDiscount);
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
    final newDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      time.hour,
      time.minute,
    );

    dateTime = newDateTime;
    notifyListeners();
  }

  void checkNoteInput() {
    if (noteController.text.isEmpty) {
      onNote = false;
      noteErrorMsg = ServiceAddLanguage.emptyDescriptionError;
    } else if (noteController.text.length < 10) {
      onNote = false;
      noteErrorMsg = 'ServiceAddLanguage.descriptionMinLenght';
    } else {
      noteErrorMsg = '';
      onNote = true;
    }
    notifyListeners();
  }

  void checkDiscountInput(String value) {
    if (value.isEmpty) {
      onDiscount = false;
      discountErrorMsg = 'roongx';
    } else if (discountCheck.hasMatch(value)) {
      onDiscount = false;
      discountErrorMsg = 'sai';
    } else {
      discountErrorMsg = '';
      onNote = true;
    }
    notifyListeners();
  }

  void enableConfirmButton() {
    if (onPhone &&
        onAddress &&
        onMoney &&
        onNote &&
        phoneController.text.isNotEmpty &&
        noteController.text.isNotEmpty &&
        totalController.text.isNotEmpty &&
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
        firstDate: DateTime(1990),
        lastDate: DateTime(2100),
      );

  Future<void> postService() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await bookingApi.postBooking(MyBookingPramsApi(
      myCustomerId: myCustomerId,
      myServices: serviceId,
      address: addressController.text.trim(),
      date: dateTime.toString().trim(),
      discount: int.parse(discountController.text.trim()),
      note: noteController.text.trim(),
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
      // await showErrorDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      // clearData();
      // await showSuccessDialog(context);
      // closeDialog(context);
    }
    notifyListeners();
  }
}
