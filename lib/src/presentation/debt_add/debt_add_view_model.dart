import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../configs/app_result/app_result.dart';
import '../../configs/configs.dart';
import '../../configs/language/debt_add_language.dart';
import '../../configs/language/debt_language.dart';
import '../../configs/language/payment_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';
import '../../resource/service/owes_invoice_api.dart';
import '../../utils/app_currency.dart';
import '../../utils/app_valid.dart';
import '../../utils/date_format_utils.dart';
import '../base/base.dart';

class DebtAddViewModel extends BaseViewModel{

  bool isMe=true;
  bool? isHideMe;
  bool isPay=true;
  bool isOwes=false;
  bool isMeOwes=false;
  bool enableButton=false;
  bool isLoading=true;
  bool isRemindMoney=false;

  OwesInvoiceApi owesInvoiceApi= OwesInvoiceApi();

  TextEditingController moneyController= TextEditingController();
  TextEditingController noteController= TextEditingController();

  DateRangePickerController dateController= DateRangePickerController();

  // OwesTotalModel? owesTotalModel;
  MyCustomerModel? myCustomerModel;

  String? messageMoney;
  String? messageOwes;

  List<int> listMoney=[];

  DateTime dateTime = DateTime.now();
  DateTime time = DateTime.now();

  Timer? timer;

  Future<void> init(MyCustomerModel? data) async{
    myCustomerModel=data;
    await fetchData();
    notifyListeners();
  }

  Future<void> fetchData() async{
    // await getOwesTotal();
    checkData();
    checkOwes();
    notifyListeners();
  }

  void setMoneyInput(int index){
    moneyController.text=AppCurrencyFormat.formatMoney(listMoney[index]);
    validPrice(moneyController.text);
    listMoney=[];
    notifyListeners();
  }

  void setShowRemind(String value){
    if(value.length>3 || value==''){
      listMoney=[];
    }else{
      listMoney=[];
      for (var i = 0; i < 3; i++) {
        listMoney.add(int.parse('$value${
          i==0? '000': i==1?'0000': i==2? '00000':'0'
        }'),);
      }
    }
    notifyListeners();
  }

  void checkData(){
    if(myCustomerModel?.isMe??false){
      isMe=true;
      // isHideMe=false;
    }else if(myCustomerModel?.isUser??false){
      isMe=false;
      // isHideMe=true;
    }
    if(myCustomerModel?.isMe==false && myCustomerModel?.isUser==false){
      isPay=false;
      isOwes=true;
    }
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
    } else{
      final money=int.parse(value.replaceAll(',', ''));
      if(money > (myCustomerModel?.money??0) && isPay){
        messageMoney = PaymentLanguage.validMoneyPay; 
      }else{
        messageMoney=null;
      }
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

  void checkOwes(){
    if(myCustomerModel?.isMe??false){
      messageOwes='${DebtLanguage.iOwe} ${
        myCustomerModel?.fullName?.split(' ').last}: ${
          AppCurrencyFormat.formatMoneyD(myCustomerModel?.money??0)}';
    }else if(myCustomerModel?.isUser??false){
      messageOwes='${myCustomerModel?.fullName?.split(' ').last} ${
        DebtLanguage.yourOwes} ${DebtLanguage.me}: ${
          AppCurrencyFormat.formatMoneyD(myCustomerModel?.money??0)}';
    }else{
      messageOwes='0';
    }
    notifyListeners();
  }

  void setButtonPerson(String? name){
    if(isOwes){
      if(name==DebtAddLanguage.me){
        isMe=true;
      }else{
        isMe=false;
      }
    }else if(!isMe && name==DebtAddLanguage.me){
      showDialogNotification(context, 
        content: '${myCustomerModel?.fullName?.split(' ').last} ${
          DebtLanguage.notificationPaidOwes}',);
    }else if(isMe && name==myCustomerModel?.fullName){
      showDialogNotification(context, 
        content: '${DebtLanguage.you} ${DebtLanguage.notificationPaidOwes}',);
    }
    notifyListeners();
  }
 
  void setButtonForm(String? name){
    if(isOwes && name=='${DebtAddLanguage.pay} ${DebtAddLanguage.yourOwes}'){
      showDialogNotification(context, content: DebtLanguage.notificationOwes);
    }else{
      if(name=='${DebtAddLanguage.pay} ${DebtAddLanguage.yourOwes}'){
        isPay=true;
      }else{
        isPay=false;
      }
      validPrice(moneyController.text.trim());
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

  dynamic showDialogNotification(_,{String? content}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WarningOneDialog(
          image: AppImages.icPlus,
          title: DebtLanguage.notification,
          content: content??'',
          buttonName: DebtLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          onTap: () {
            Navigator.pop(context,);
          },
        );
      },
    );
  }

  dynamic showErrorDialog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
        );
      },
    );
  }

  dynamic showDialogSuccess(_) {
    showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          content: BookingLanguage.addSuccess,
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
          leftButtonName: SignUpLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: BookingLanguage.debt,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  dynamic showSuccessDiaglog(_) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
        );
      },
    );
  }

  void closeDialog(BuildContext context) {
    timer = Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  void clearData(){
    enableButton=false;
    noteController.text='';
    moneyController.text='';
    dateTime = DateTime.now();
    time = DateTime.now();
    notifyListeners();
  }

  Future<void> postDebt() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await owesInvoiceApi.postOwes(OwesInvoiceParams(
      money: int.parse(moneyController.text.replaceAll(',', '')),
      note: noteController.text.trim(),
      date: '${dateTime.toString().split(' ')[0]} ${
        AppDateUtils.formatTimeToHHMM(time)}',
      isUser: !isMe ? !isMe: null,
      isMe: isMe ? isMe: null,
      id: myCustomerModel?.id,
      isDebit: !isPay
    ),);

    final value = switch (result) {
      Success(value: final customer) => customer,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      LoadingDialog.hideLoadingDialog(context);
      clearData();
      showDialogSuccess(context);
    }
    notifyListeners();
  }

  // Future<void> getOwesTotal() async {
  //   final result = await owesInvoiceApi.getTotalOwesInvoice(
  //     OwesInvoiceParams(
  //       id: myCustomerModel?.id,
  //     ),
  //   );

  //   final value = switch (result) {
  //     Success(value: final customer) => customer,
  //     Failure(exception: final exception) => exception,
  //   };

  //   if (!AppValid.isNetWork(value)) {
  //     isLoading = true;
  //   } else if (value is Exception) {
  //     isLoading = true;
  //   } else {
  //     owesTotalModel = value as OwesTotalModel;
  //     isLoading=false;
  //   }
  //   notifyListeners();
  // }

  @override
  void dispose() {
    timer?.cancel();
    moneyController.dispose();
    noteController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
