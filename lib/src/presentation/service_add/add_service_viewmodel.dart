import 'package:flutter/material.dart';
import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/my_customer_model.dart';
import '../../resource/model/my_service_model.dart';
import '../../resource/service/auth.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

import '../routers.dart';
import 'components/choose_service_widget.dart';

class ServiceAddViewModel extends BaseViewModel {
  final List<Widget> fields = [];
  String? messageService;

  late Object dropValue = myService.first;

  String searchText = '';
  DateTime dateTime = DateTime.now();

  List<String> selectedServices = [];

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

  final phoneCkeckText = RegExp(r'[a-zA-Z!@#$%^&*()]');
  final phoneCkeckQuantity = RegExp(r'^(\d{0,9}|\d{11,})$');
  final specialCharsCheck = RegExp(r'[`~!@#$%^&*()"-=_+{};:\|.,/?]');
  final numberCheck = RegExp('0123456789');
  final moneyCharsCheck = RegExp(r'^\d+$');

  bool enableButton = false;
  AuthApi authApi = AuthApi();
  Future<void> init() async {
    test();
    await fechService();
    await fechCustomer();
    notifyListeners();
  }

  Future<void> fechService() async {
    // LoadingDialog.showLoadingDialog(context);
    final result = await authApi.getService();

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

  Future<void> fechCustomer() async {
    // LoadingDialog.showLoadingDialog(context);
    final result = await authApi.getMyCustomer();

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

  void setDropValue(Object value) {
    dropValue = value.toString();

    calculateTotalPrice();
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
    fields.removeAt(index);
    notifyListeners();
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

  void test() {
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

  void addService(service) {
    selectedServices.add(service);
    notifyListeners();
  }

  void removeService(String service) {
    selectedServices.remove(service);
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

  // List<Contact> contacts = [
  //   Contact(phoneNumber: '0123456789', name: 'Nguyễn Văn A'),
  //   Contact(phoneNumber: '0987654321', name: 'Trần Thị B'),
  //   Contact(phoneNumber: '0774423626', name: 'Lê Thanh Hòa'),
  //   Contact(phoneNumber: '0774423624', name: 'Lê Thanh Hà'),
  // ];

  List<MyCustomerModel> getContactSuggestions(String searchText) {
    final results = myCustumer
        .where((myCustumer) =>
            myCustumer.phoneNumber!.contains(searchText) ||
            myCustumer.fullName!.contains(searchText))
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

  double totalPrice = 0.0;
  void calculateTotalPrice() {
    totalPrice += calculatePrice(dropValue);
    moneyController.text = totalPrice.toString();
  }

  double calculatePrice(Object dropValue) {
    switch (dropValue) {
      case 'abc':
        return 100000;
      case 'xyz':
        return 200000;
      case 'đi cháy phố':
        return 300000;
      case 'đi hẹn hò':
        return 400000;
      case 'đi chơi xuyên đêm':
        return 500000;
      default:
        return 0;
    }
  }
}

// class Contact {
//   String phoneNumber;
//   String name;

//   Contact({required this.phoneNumber, required this.name});
// }
