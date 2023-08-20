import 'package:flutter/material.dart';

import '../../configs/language/booking_language.dart';
import '../base/base.dart';

class BookingViewModel extends BaseViewModel{
  dynamic init(){}
  List<String> list = <String>['', 'abc', 'xyz',
   'đi cháy phố', 'đi hẹn hò', 'đi chơi xuyên đêm'];
  final TextEditingController addressController=TextEditingController();
  late Object dropValue=list.first;

  void setDropValue(Object value){
    dropValue=value;
    notifyListeners();
  }

  bool enableSignIn = false;
  String messageErorAddress='';
  String? messageHour;
  String? messageService;
  String dateTime = 'hh:mm dd-mm-yyyy';

  void voidSetDate(DateTime newDate) {
    final time= setTime(newDate);
    dateTime = '$time ${BookingLanguage.date} ${newDate.day}/${newDate.month}/${newDate.year}';
    notifyListeners();
  }

  String setTime(DateTime newDate){
    if(newDate.minute<10){
      return '${newDate.hour}h:0${newDate.minute}';
    }else{
      return '${newDate.hour}h:${newDate.minute}';
    }
  }

  void validAddress(String? value) {
    if (value == null || value.isEmpty) {
      messageErorAddress= BookingLanguage.addressIsEmpty;
    }else if(value.length<12){
      messageErorAddress=BookingLanguage.validAddress;
    }else{
      messageErorAddress='';
    }
    notifyListeners();
  }

  void validHour() {
    if (dateTime=='hh:mm dd-mm-yyyy') {
      messageHour= BookingLanguage.validHour;
    }else{
      messageHour='';
    }
    notifyListeners();
  }

  void validService() {
    if (dropValue==list.first) {
      messageService= BookingLanguage.validService;
    }else{
      messageService='';
    }
    notifyListeners();
  }

  void onSignIn() {
    if (messageErorAddress == '') {
      enableSignIn = true;
    } else {
      enableSignIn = false;
    }
    notifyListeners();
  }
}