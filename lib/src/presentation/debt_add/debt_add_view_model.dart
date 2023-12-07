import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../configs/language/debt_add_language.dart';
import '../../configs/language/payment_language.dart';
import '../../resource/model/model.dart';
import '../../utils/app_currency.dart';
import '../base/base.dart';

class DebtAddViewModel extends BaseViewModel{

  bool isMe=true;
  bool isPay=true;
  bool enableButton=true;

  TextEditingController moneyController= TextEditingController();
  TextEditingController noteController= TextEditingController();

  DateRangePickerController dateController= DateRangePickerController();

  MyCustomerModel? myCustomerModel;

  String? messageMoney;

  DateTime dateTime = DateTime.now();
  DateTime time = DateTime.now();

  Future<void> init(MyCustomerModel? data) async{
    myCustomerModel=data;
    notifyListeners();
  }

  Future<void> pullRefresh()async{
    notifyListeners();
  }

  Future<void> updateDateTime(DateTime time) async {
    dateTime = time;
    notifyListeners();
  }

  Future<void> updateTime(DateTime times) async {
    time = times;
    notifyListeners();
  }

  void validPrice(String? value) {
    if (value == null || value.isEmpty) {
      messageMoney = PaymentLanguage.emptyMoneyError;
    } else {
      messageMoney = null; 
    }
    notifyListeners();
  }

  void formatMoney(String? value) {
    if (value != null && value.isNotEmpty) {
      final valueFormat =
          AppCurrencyFormat.formatNumberEnter(value.replaceAll(',', ''));
      moneyController.value = TextEditingValue(
        text: valueFormat,
        selection: TextSelection.collapsed(offset: valueFormat.length),
      );
    }
    notifyListeners();
  }

  void setButtonPerson(String? name){
    if(name==DebtAddLanguage.me){
      isMe=true;
    }else{
      isMe=false;
    }
    notifyListeners();
  }

  void setButtonForm(String? name){
    if(name==DebtAddLanguage.pay){
      isPay=true;
    }else{
      isPay=false;
    }
    notifyListeners();
  }

  void onSubmit() {
    if (messageMoney == null && moneyController.text != '') {
      enableButton = true;
    } else {
      enableButton = false;
    }
    notifyListeners();
  }
}
