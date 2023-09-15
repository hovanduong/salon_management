// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../configs/configs.dart';
import '../../resource/model/my_customer_model.dart';
import '../../resource/model/my_service_model.dart';
import '../../resource/service/auth.dart';
import '../../resource/service/my_customer_api.dart';
import '../../resource/service/my_service_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

import '../routers.dart';
import 'components/choose_service_widget.dart';

class BookingViewModel extends BaseViewModel {
  final List<Widget> fields = [];
  String? messageService;

  late Object dropValue = myService.first;

  String searchText = '';
  DateTime dateTime = DateTime.now();

  List<String>? selectedServices = [];

  List<MyCustomerModel> searchResults = [];
  bool isListViewVisible = false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final moneyController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();

  bool onAddress = true;
  bool onPhone = true;
  bool onTopic = true;
  bool onMoney = true;
  bool onTime = true;
  bool onDescription = true;

  String? phoneErrorMsg;
  String? topicErrorMsg;
  String? moneyErrorMsg;
  String? timeErrorMsg;
  String? descriptionErrorMsg;

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
    findPhone();
    await fetchService();
    await fetchCustomer();
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


  void changeIsListViewVisible(bool isSelectPhone) {
    if (isSelectPhone) {
      isListViewVisible = false;
    } else {
      isListViewVisible = true;
    }
    notifyListeners();
  }

  void setDropValue(dynamic value) {
    dropValue = value.toString();
    calculateTotalPrice();
    notifyListeners();
  }

  double totalPrice = 0;
  void calculateTotalPrice() {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

    totalPrice = calculateTotalPriceByName(dropValue, myService);
    final totalPriceT = currencyFormatter.format(totalPrice);
    moneyController.text = totalPriceT;
  }

  double calculateTotalPriceByName(
      dynamic selectedName, List<MyServiceModel> myService) {
    final selectedItems =
        myService.where((item) => item.name == selectedName).toList();

    for (final item in selectedItems) {
      totalPrice += double.parse(item.money!);
    }

    return totalPrice;
  }

  void addNewField() {
    fields.add(
      ChooseServiceWidget(
        list: myService,
        onChanged: (value) {
          setDropValue(value);

          validService();
        },
        labelText: HomeLanguage.service,
        // dropValue: null,
        onRemove: () {
          removeField(fields.length - 1);
        },
      ),
    );
    notifyListeners();
  }

  void validService() {
    if (dropValue == myService.first) {
      messageService = 'BookingLanguage.validService';
    } else {
      messageService = '';
    }
    notifyListeners();
  }

  void removeField(int index) {
    MyServiceModel? removedItem;

    for (final item in myService) {
      if (item.name == dropValue) {
        removedItem = item;
        break;
      }
    }

    if (removedItem != null) {
      totalPrice -= double.parse(removedItem.money!);
      moneyController.text = totalPrice.toString();
    }

    fields.removeAt(index);
    notifyListeners();
  }

  void findPhone() {
    phoneController.addListener(() {
      searchText = phoneController.text;
      searchResults = getContactSuggestions(searchText);
    });
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



  void checkDescriptionInput() {
    if (descriptionController.text.isEmpty) {
      onDescription = false;
      descriptionErrorMsg = ServiceAddLanguage.emptyDescriptionError;
    } else if (descriptionController.text.length < 10) {
      onDescription = false;
      descriptionErrorMsg = ServiceAddLanguage.descriptionMinLenght;
    } else {
      descriptionErrorMsg = '';
      onDescription = true;
    }
    notifyListeners();
  }

  void enableConfirmButton() {
    if (onPhone &&
        onAddress &&
        onMoney &&
        onDescription &&
        phoneController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        moneyController.text.isNotEmpty &&
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


  List<MyCustomerModel> getContactSuggestions(String searchText) {
    final results = myCustumer
        .where(
          (myCustumer) =>
              myCustumer.phoneNumber!.contains(searchText) ||
              myCustumer.fullName!.contains(searchText),
        )
        .toList();

    print(results);

    return results;
  }

  void updatePhoneNumber(String selectedPhoneNumber) {
    phoneController.text = selectedPhoneNumber;
    searchText = selectedPhoneNumber;
    searchResults = getContactSuggestions(searchText);
    findName();
    isListViewVisible = true;
    notifyListeners();
  }

  void findName() {
    final phoneNumber = phoneController.text;
    var found = false;

    for (final contact in myCustumer) {
      if (phoneNumber == contact.phoneNumber) {
        nameController.text = contact.fullName!;
        notifyListeners();
        found = true;
        break;
      }
    }

    if (!found) {
      nameController.text = 'Không tìm thấy';
      notifyListeners();
    }
  }
}

