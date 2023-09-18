import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  String? phoneErrorMsg;
  String? topicErrorMsg;
  String? moneyErrorMsg;
  String? timeErrorMsg;
  String? noteErrorMsg;

  List<MyServiceModel> myService = [];
  List<MyCustomerModel> myCustumer = [];

  final phoneCheckText = RegExp(r'[a-zA-Z!@#$%^&*()]');
  final phoneCheckQuantity = RegExp(r'^(\d{0,9}|\d{11,})$');
  final specialCharsCheck = RegExp(r'[`~!@#$%^&*()"-=_+{};:\|.,/?]');
  final numberCheck = RegExp('0123456789');
  final moneyCharsCheck = RegExp(r'^\d+$');
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
    if (selectedService.isNotEmpty) {
      selectedService.forEach((element) {
        serviceId.add(element.id!);
      });
    }
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
  void calculateTotalPrice() {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

    totalPrice = calculateTotalPriceByName(myService, serviceId);
    final totalPriceT = currencyFormatter.format(totalPrice);
    totalController.text = totalPriceT;
  }

  num calculateTotalPriceByName(
      List<MyServiceModel> myService, List<int> serviceID) {
    num totalCost = 0;

    for (final id in serviceID) {
      // ignore: lines_longer_than_80_chars
      final service =
          myService.firstWhere((s) => s.id == id, orElse: MyServiceModel.new);
      totalCost += service.money ?? 0;
    }
    print(serviceID);
    print('object');
    print(totalCost);
    return totalCost;
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
      noteErrorMsg = ServiceAddLanguage.descriptionMinLenght;
    } else {
      noteErrorMsg = '';
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
    final result = await bookingApi.postBooking(MyBookingModel(
      id: myCustomerId,
      //   myServices: [
      //   MyServiceModel(
      //     id: serviceId,
      //   ),
      // ],
      address: addressController.text,
      note: noteController.text,
      date: dateTime.toString(),
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
