import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../resource/model/model.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class UpdateProfileViewModel extends BaseViewModel {
  bool isBorderCity = false;
  bool enableSignIn = false;

  String? messageFullName;
  String? messageEmail;
  String date = 'dd-mm-yyyy';
  String? gender;

  TextEditingController fullNameController= TextEditingController();
  TextEditingController emailController= TextEditingController();

  List<String> genderList = [
    UpdateProfileLanguage.male,
    UpdateProfileLanguage.female,
    UpdateProfileLanguage.other,
  ];

  dynamic init() {
    gender=genderList.first;
  }

  Future<void> onToCreatePassword(BuildContext context, String phone) async{
    final user=  UserModel(
      phoneNumber: phone,
      email: emailController.text,
      fullName: fullNameController.text,
      gender: gender
    );
    await Navigator.pushNamed(context, Routers.createPassword, 
        arguments: RegisterArguments( userModel: user),
      );
  }

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void validFullName(String? value) {
    final result = AppValid.validateFullName(value);
    if (result != null) {
      messageFullName = result;
    } else {
      messageFullName = null;
    }
    notifyListeners();
  }

  void validEmail(String? value) {
    final result = AppValid.validateEmail(value);
    if (result != null) {
      messageEmail = result;
    } else {
      messageEmail = null;
    }
    notifyListeners();
  }

  void onSignIn() {
    if (messageFullName == null && messageEmail == null) {
      enableSignIn = true;
    } else {
      enableSignIn = false;
    }
    notifyListeners();
  }

  dynamic showOpenDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          onTap: () {
            Navigator.pop(context);
          },
          image: AppImages.icPlus,
          title: UpdateProfileLanguage.success,
        );
      },
    );
  }
}
