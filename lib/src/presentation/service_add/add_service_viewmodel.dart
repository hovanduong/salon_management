import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import '../routers.dart';
import 'components/photo_picker_widget.dart';

class ServiceAddViewModel extends BaseViewModel {
  File? imageFile;

  DateTime dateTime = DateTime.now();

  String selectedTimeText = '';
  List<String> selectedServices = [];

  TextEditingController nameController = TextEditingController();
  final phoneController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
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

  final phoneCkeckText = RegExp(r'[a-zA-Z!@#$%^&*()]');
  final phoneCkeckQuantity = RegExp(r'^(\d{0,9}|\d{11,})$');
  final specialCharsCheck = RegExp(r'[`~!@#$%^&*()"-=_+{};:\|.,/?]');
  final numberCheck = RegExp('0123456789');
  final moneyCharsCheck = RegExp(r'^\d+$');

  bool enableButton = false;
  bool isImageUploaded = false;

  dynamic init() {}

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

  void checkPhoneInput() {
    if (phoneController.text.isEmpty) {
      onPhone = false;
      phoneErrorMsg = 'rỗng';
    } else if (phoneCkeckText.hasMatch(phoneController.text)) {
      onPhone = false;
      phoneErrorMsg = 'Không nhập chữ cái và kí tự đặt biệt';
    } else if (phoneCkeckQuantity.hasMatch(phoneController.text)) {
      onPhone = false;
      phoneErrorMsg = 'nhập sai định dạng';
    } else {
      onPhone = true;
      phoneErrorMsg = '';
    }
    notifyListeners();
  }

  // void checkTopicInput() {
  //   if (topicNameController.text.isEmpty) {
  //     onTopic = false;
  //     topicErrorMsg = ServiceAddLanguage.emptyNameError;
  //   } else if (specialCharsCheck.hasMatch(topicNameController.text)) {
  //     onTopic = false;
  //     topicErrorMsg = ServiceAddLanguage.specialCharsError;
  //   } else if (numberCheck.hasMatch(topicNameController.text)) {
  //     onTopic = false;
  //     topicErrorMsg = ServiceAddLanguage.specialCharsError;
  //   } else if (topicNameController.text.length < 6) {
  //     onTopic = false;
  //     topicErrorMsg = ServiceAddLanguage.serviceNameMinLenght;
  //   } else {
  //     onTopic = true;
  //     topicErrorMsg = '';
  //   }
  //   notifyListeners();
  // }

  // void checkMoneyInput() {
  //   if (moneyController.text.isEmpty) {
  //     onMoney = false;
  //     moneyErrorMsg = ServiceAddLanguage.emptyMoneyError;
  //   } else if (!moneyCharsCheck.hasMatch(moneyController.text)) {
  //     moneyErrorMsg = ServiceAddLanguage.onlyDenominations;
  //     onMoney = false;
  //   } else {
  //     moneyErrorMsg = '';
  //     onMoney = true;
  //   }
  //   notifyListeners();
  // }

  // void checkTimeInput() {
  //   if (timeController.text.isEmpty) {
  //     onTime = false;
  //     timeErrorMsg = ServiceAddLanguage.emptyTimeError;
  //   } else if (!moneyCharsCheck.hasMatch(timeController.text)) {
  //     timeErrorMsg = ServiceAddLanguage.onlyNumberOfTime;
  //     onTime = false;
  //   } else {
  //     timeErrorMsg = '';
  //     onTime = true;
  //   }
  //   notifyListeners();
  // }

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

  // Future<void> getImage(ImageSource? source) async {
  //   final file = await ImagePicker().pickImage(source: source!);

  //   if (file?.path != null) {
  //     imageFile = File(file!.path);
  //     isImageUploaded = false;
  //     notifyListeners();
  //   }
  // }

  // GestureDetector choosePhoto() {
  //   return GestureDetector(
  //     onTap: () => getImage(ImageSource.gallery),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Paragraph(
  //           content: ServiceAddLanguage.choosePhoto,
  //           style: STYLE_MEDIUM_BOLD,
  //         ),
  //         SizedBox(height: SpaceBox.sizeSmall),
  //         if (imageFile != null)
  //           PhotoPickerWidget(
  //             decorationImage: DecorationImage(
  //               image: FileImage(imageFile!),
  //               fit: BoxFit.cover,
  //             ),
  //           )
  //         else
  //           const PhotoPickerWidget(
  //             icon: Icon(
  //               Icons.add,
  //               color: AppColors.PRIMARY_PINK,
  //               size: 40,
  //             ),
  //           )
  //       ],
  //     ),
  //   );
  // }

  //  GestureDetector(
  //         onTap: () => _viewModel!.getImage(ImageSource.gallery),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Paragraph(
  //               content: serviceAddLanguage.serviceAddChoosePhoto,
  //               style: STYLE_MEDIUM_BOLD,
  //             ),
  //             SizedBox(height: SpaceBox.sizeSmall),
  //             if (_viewModel!.imageFile != null)
  //               PhotoPickerWidget(
  //                 decorationImage: DecorationImage(
  //                   image: FileImage(_viewModel!.imageFile!),
  //                   fit: BoxFit.cover,
  //                 ),
  //               )
  //             else
  //               const PhotoPickerWidget(
  //                 icon: Icon(
  //                   Icons.add,
  //                   color: AppColors.PRIMARY_PINK,
  //                   size: 40,
  //                 ),
  //               )
  //           ],
  //         ),
  //       ),

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

  List<Contact> contacts = [
    Contact(phoneNumber: "0123456789", name: "Nguyễn Văn A"),
    Contact(phoneNumber: "0987654321", name: "Trần Thị B"),
    Contact(phoneNumber: "0774423626", name: "Lê Thanh Hòa"),
  ];

  void findName() {
    final phoneNumber = phoneController.text;
    var found = false;

    for (final contact in contacts) {
      if (phoneNumber == contact.phoneNumber) {
        nameController.text = contact.name;
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

  void calculateTotalPrice(String selectedService) {
    double totalPrice = 0.0;
    for (String service in selectedServices) {
      totalPrice += calculatePrice(service);
    }
    moneyController.text = totalPrice.toStringAsFixed(2);
    ;
  }

  double calculatePrice(String serviceName) {
    switch (serviceName) {
      case 'Dịch vụ 1':
        return 100000;
      case 'Dịch vụ 2':
        return 200000;
      case 'Dịch vụ 3':
        return 300000;
      default:
        return 0;
    }
  }
}

class Contact {
  String phoneNumber;
  String name;

  Contact({required this.phoneNumber, required this.name});
}
