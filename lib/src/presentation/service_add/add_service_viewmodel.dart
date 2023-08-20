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

  TimeOfDay pickedTime = const TimeOfDay(hour: 00, minute: 00);
  String selectedTimeText = '';

  final topicNameController = TextEditingController();
  final moneyController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();

  bool onTopic = true;
  bool onMoney = true;
  bool onTime = true;
  bool onDescription = true;

  String? topicErrorMsg;
  String? moneyErrorMsg;
  String? timeErrorMsg;
  String? descriptionErrorMsg;

  final specialCharsCheck = RegExp(r'[`~!@#$%^&*()"-=_+{};:\|.,/?]');
  final numberCheck = RegExp('0123456789');
  final moneyCharsCheck = RegExp(r'^\d+$');

  bool enableButton = false;
  bool isImageUploaded = false;

  dynamic init() {}

  void checkTopicInput() {
    if (topicNameController.text.isEmpty) {
      onTopic = false;
      topicErrorMsg = ServiceAddLanguage.emptyNameError;
    } else if (specialCharsCheck.hasMatch(topicNameController.text)) {
      onTopic = false;
      topicErrorMsg = ServiceAddLanguage.specialCharsError;
    } else if (numberCheck.hasMatch(topicNameController.text)) {
      onTopic = false;
      topicErrorMsg = ServiceAddLanguage.specialCharsError;
    } else if (topicNameController.text.length < 6) {
      onTopic = false;
      topicErrorMsg = ServiceAddLanguage.serviceNameMinLenght;
    } else {
      onTopic = true;
      topicErrorMsg = '';
    }
    notifyListeners();
  }

  void checkMoneyInput() {
    if (moneyController.text.isEmpty) {
      onMoney = false;
      moneyErrorMsg = ServiceAddLanguage.emptyMoneyError;
    } else if (!moneyCharsCheck.hasMatch(moneyController.text)) {
      moneyErrorMsg = ServiceAddLanguage.onlyDenominations;
      onMoney = false;
    } else {
      moneyErrorMsg = '';
      onMoney = true;
    }
    notifyListeners();
  }

  void checkTimeInput() {
    if (timeController.text.isEmpty) {
      onTime = false;
      timeErrorMsg = ServiceAddLanguage.emptyTimeError;
    } else if (!moneyCharsCheck.hasMatch(timeController.text)) {
      timeErrorMsg = ServiceAddLanguage.onlyNumberOfTime;
      onTime = false;
    } else {
      timeErrorMsg = '';
      onTime = true;
    }
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

  Future<void> getImage(ImageSource? source) async {
    final file = await ImagePicker().pickImage(source: source!);

    if (file?.path != null) {
      imageFile = File(file!.path);
      isImageUploaded = false;
      notifyListeners();
    }
  }

  GestureDetector choosePhoto() {
    return GestureDetector(
      onTap: () => getImage(ImageSource.gallery),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Paragraph(
            content: ServiceAddLanguage.choosePhoto,
            style: STYLE_MEDIUM_BOLD,
          ),
          SizedBox(height: SpaceBox.sizeSmall),
          if (imageFile != null)
            PhotoPickerWidget(
              decorationImage: DecorationImage(
                image: FileImage(imageFile!),
                fit: BoxFit.cover,
              ),
            )
          else
            const PhotoPickerWidget(
              icon: Icon(
                Icons.add,
                color: AppColors.PRIMARY_PINK,
                size: 40,
              ),
            )
        ],
      ),
    );
  }

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
    if (onTopic &&
        onMoney &&
        onTime &&
        onDescription &&
        topicNameController.text.isNotEmpty &&
        moneyController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
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
}
