import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../configs/configs.dart';
import '../../resource/model/model.dart';
import '../../utils/app_valid.dart';
import '../../utils/city_vietnam.dart';
import '../base/base.dart';
import '../routers.dart';

class UpdateProfileViewModel extends BaseViewModel {
  bool enableSignIn = false;
  String? messageFirstName;
  String? messageLastName;
  String? messageCity;
  String? messageDate;
  String? messageGender;
  bool isBorderCity = false;
  List<String> cityModels = ['-'];
  String nameCity = UpdateProfileLanguage.selectCity;
  String gender = UpdateProfileLanguage.gender;
  String date = 'dd-mm-yyyy';
  String? firstName;
  String? lastName;
  File? file;

  List<String> genderList = [
    UpdateProfileLanguage.gender,
    UpdateProfileLanguage.male,
    UpdateProfileLanguage.female,
    UpdateProfileLanguage.other,
  ];
  int? selectedCityIndex;
  int? selectedGenderIndex;

  dynamic init() {}
  Future<void> onToCreatePassword(BuildContext context, String phone) async{
    final user=  UserModel(
      avatar: file?.path,
      birthDate: date,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
    await Navigator.pushNamed(context, Routers.createPassword, 
        arguments: RegisterArguments( userModel: user),
      );
  }

  void setDate(DateTime newDate) {
    date = '${newDate.day} - ${newDate.month} - ${newDate.year}';
    notifyListeners();
  }

  void changBorderCity() {
    isBorderCity = !isBorderCity;
    notifyListeners();
  }

  void changeGenderIndex(int index) {
    selectedGenderIndex = index;
    notifyListeners();
  }

  void changSelectedIndex(int index) {
    selectedCityIndex = index;
    notifyListeners();
  }

  void setNameGender() {
    if (selectedGenderIndex != null) {
      gender = genderList[selectedGenderIndex!];
    }
    notifyListeners();
  }

  void setNameCity() {
    if (selectedCityIndex != null) {
      nameCity = AppCityVietNam.listCity[selectedCityIndex!];
    }
    notifyListeners();
  }

  void validFirstName(String? value) {
    firstName=value;
    final result = AppValid.validateFullName(value);
    if (result != null) {
      messageFirstName = result;
    } else {
      messageFirstName = null;
    }
    notifyListeners();
  }

  void validLastName(String? value) {
    lastName=value;
    final result = AppValid.validateFullName(value);
    if (result != null) {
      messageLastName = result;
    } else {
      messageLastName = null;
    }
    notifyListeners();
  }

  void onSignIn() {
    if (messageFirstName == null && messageLastName == null
      && nameCity != UpdateProfileLanguage.selectCity 
      && gender != UpdateProfileLanguage.gender
      && date!='dd-mm-yyyy') {
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

  void validCity() {
    if (nameCity==UpdateProfileLanguage.selectCity) {
      messageCity= UpdateProfileLanguage.validCity;
    }else{
      messageCity=null;
    }
    notifyListeners();
  }

  void validGender() {
    if (gender==UpdateProfileLanguage.gender) {
      messageGender= UpdateProfileLanguage.validGender;
    }else{
      messageGender=null;
    }
    notifyListeners();
  }

  void validDate() {
    if (date=='dd-mm-yyyy') {
      messageDate= UpdateProfileLanguage.validDateOfBirth;
    }else{
      messageDate=null;
    }
    notifyListeners();
  }

  // void checkInfor(BuildContext context, String phone){
  //   if(nameCity != UpdateProfileLanguage.selectCity 
  //     && gender !=UpdateProfileLanguage.gender
  //     && date!='dd-mm-yyyy'){
  //     validCity();
  //     validDate();
  //     validGender();
  //     onToCreatePassword(context, phone);
  //   }else{
  //     validCity();
  //     validDate();
  //     validGender();
  //   }
  // }

  // Future<void> checkInternet(Function() onSuccess, BuildContext context) async{
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       onSuccess();
  //     }
  //   } on SocketException catch (_) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('not connected '), 
  //       duration: Duration(seconds: 2),),
  //     );
  //   }
  //   notifyListeners();
  // }


  Future getImage() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image==null){
        return;
      }
      // final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);
      file = imagePermanent;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick  image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async{
    final directory = await getApplicationDocumentsDirectory();
    final name= basename(imagePath);
    final image= File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }
}
