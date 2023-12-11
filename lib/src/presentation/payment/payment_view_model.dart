// ignore_for_file: lines_longer_than_80_chars, cast_nullable_to_non_nullable, avoid_bool_literals_in_conditional_expressions

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../configs/configs.dart';
import '../../configs/language/payment_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';

import '../../resource/service/booking.dart';
import '../../resource/service/category_api.dart';
import '../../resource/service/invoice.dart';
import '../../resource/service/my_booking.dart';
import '../../resource/service/my_customer_api.dart';
import '../../utils/app_currency.dart';
import '../../utils/app_valid.dart';
import '../../utils/date_format_utils.dart';
import '../../utils/utils.dart';
import '../base/base.dart';

import '../routers.dart';

class PaymentViewModel extends BaseViewModel {
  BookingApi bookingApi = BookingApi();
  CategoryApi categoryApi= CategoryApi();
  MyCustomerApi myCustomerApi = MyCustomerApi();
  MyBookingApi myBookingApi = MyBookingApi();
  InvoiceApi invoiceApi = InvoiceApi();
  // MyServiceApi myServiceApi = MyServiceApi();

  List<int>? myServiceId = [];
  List<int> serviceId = [];
  List<int> listMoney = [];

  // List<RadioModel> selectedService = [];
  // List<MyServiceModel> myService = [];
  List<MyBookingModel> listMyBooking=[];
  List<CategoryModel> listCategory = [];
  List<CategoryModel> listCategoryIncome = [];
  List<CategoryModel> listCategoryExpense = [];

  Timer? timer;

  int? myCustomerId;
  int? selectedCategory;
  int? categoryId;

  // num totalCost = 0;
  // num totalPrice = 0;
  // num updatedTotalCost = 0;

  DateTime dateTime = DateTime.now();
  DateTime time = DateTime.now();

  MyBookingModel? dataMyBooking;
  MyCustomerModel? myCustomerModel;

  // Map<int, String> mapService = {};
  // Map<int, String> mapPhone = {};

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  DateRangePickerController dateController= DateRangePickerController();
  // final totalController = TextEditingController();
  // TextEditingController discountController = TextEditingController();

  // DateRangePickerController dateController = DateRangePickerController();

  // bool onAddress = true;
  // bool onPhone = true;
  // bool onTopic = true;
  // bool onMoney = true;
  // bool onTime = true;
  // bool onDiscount = true;
  bool onNote = true;
  bool isListViewVisible = false;
  bool enableButton = false;
  bool isLoading=true;
  bool isButtonSpending=false;
  bool isShowAll=false;
  bool isShowCase=true;

  String? phoneErrorMsg;
  String? topicErrorMsg;
  String? moneyErrorMsg;
  String? timeErrorMsg;
  String? noteErrorMsg;
  String? addressMsg;
  String? discountErrorMsg;
  String? messageService;
  String searchText = '';
  String? prices;
  String? services;
  String? money;
  String? messageErrorPrice;

  final currencyFormatter =
      NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

  final phoneCheckText = RegExp(r'[a-zA-Z!@#$%^&*()]');
  final phoneCheckQuantity = RegExp(r'^(\d{0,9}|\d{11,})$');
  final specialCharsCheck = RegExp(r'[`~!@#$%^&*()"-=_+{};:\|.,/?]');
  final numberCheck = RegExp('0123456789');
  final moneyCharsCheck = RegExp(r'^\d+$');
  final onlySpecialChars = RegExp(r'^[\s,\-]*$');

  GlobalKey keyInfoCustomer= GlobalKey();
  GlobalKey keyMoney= GlobalKey();
  GlobalKey key= GlobalKey();
  GlobalKey keyAddCategory= GlobalKey();
  GlobalKey keyCategory= GlobalKey();
  GlobalKey keyDateTime= GlobalKey();

  Future<void> init() async {
    await getCategory();
    selectedCategory=0;
    categoryId=listCategory[0].id;
    isButtonSpending=false;
    // await setDataMyBooking(myBookingModel);
    // await fetchService();
    // await fetchCustomer();
    // await initMapCustomer();
    // await initMapService();
    await AppPref.getShowCase('showCasePayment').then(
      (value) => isShowCase=value??true,);
    startShowCase();
    await hideShowcase();
    notifyListeners();
  }

  Future<void> hideShowcase() async{
    await AppPref.setShowCase('showCasePayment', false);
    isShowCase=false;
    notifyListeners();
  }

  void startShowCase(){
    if(isShowCase){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowCaseWidget.of(context).startShowCase(
          [keyInfoCustomer,keyMoney,key, keyAddCategory, keyCategory, keyDateTime],
        );
      });
    }
  }

  Future<void> goToBill(BuildContext context) 
    => Navigator.pushNamed(context, Routers.bill, 
      arguments: listMyBooking[0],);
  
  Future<void> goToAddCategory(BuildContext context) async {
    await Navigator.pushNamed(context, Routers.addCategory,);
    await init();
  } 


  void setButtonSelect(String name){
    if(name==PaymentLanguage.income){
      categoryId=listCategoryIncome[0].id;
      listCategory=listCategoryIncome;
      isButtonSpending=false;
    }else{
      listCategory=listCategoryExpense;
      categoryId=listCategoryExpense[0].id;
      isButtonSpending=true;
    }
    isShowAll=false;
    selectedCategory=0;
    notifyListeners();
  }

  void setCategorySelected(int index){
    if(index==16 || index ==17){
      isShowAll=!isShowAll;
    }else{
      selectedCategory=index;
      categoryId=listCategory[index].id;
    }
    enableConfirmButton();
    notifyListeners();
  }

  // Future<void> setDataMyBooking(MyBookingModel? myBookingModel) async {
  //   if (myBookingModel != null) {
  //     dataMyBooking = myBookingModel;
  //     phoneController.text = dataMyBooking!.myCustomer!.phoneNumber!;
  //     nameController.text = dataMyBooking!.myCustomer!.fullName!;
  //     addressController.text = dataMyBooking!.address!;
  //     noteController.text =
  //         dataMyBooking!.note != 'Trống' ? dataMyBooking!.note! : '';
  //     // setSelectedService();
  //     // await setServiceId();
  //     // await fetchService();
  //     // await calculateTotalPriceByName();
  //     enableConfirmButton();
  //   }
  //   notifyListeners();
  // }

  // Future<void> goToAddMyCustomer(BuildContext context) async {
  //   myCustomerModel= 
  //     await Navigator.pushNamed(context, Routers.myCustomerAdd, arguments: true)
  //     as MyCustomerModel?;
  //   await setDataCustomer();
  // }

  // Future<void> setDataCustomer() async{
  //   nameController.text=myCustomerModel!.fullName ?? '';
  //   phoneController.text=myCustomerModel!.phoneNumber ?? '';
  //   await fetchCustomer();
  //   myCustomerId= myCustomer.where((element) => 
  //     element.phoneNumber==myCustomerModel!.phoneNumber,).first.id;
  //   notifyListeners();
  // }

  // void setSelectedService() {
  //   if (dataMyBooking!.myServices!.isNotEmpty) {
  //     dataMyBooking?.myServices!.forEach((service) {
  //       selectedService.add(RadioModel(
  //         isSelected: true,
  //         id: service.id,
  //         name: '${service.name}/${AppCurrencyFormat.formatMoneyVND(service.money!)}',
  //       ),);
  //     });
  //   }
  // }

  // Future<void> fetchService() async {
  //   final result = await myServiceApi.getService();

  //   final value = switch (result) {
  //     Success(value: final accessToken) => accessToken,
  //     Failure(exception: final exception) => exception,
  //   };

  //   if (!AppValid.isNetWork(value)) {
  //   } else if (value is Exception) {
  //   } else {
  //     myService = value as List<MyServiceModel>;
  //   }
  //   notifyListeners();
  // }

  // Future<void> fetchCustomer() async {
  //   final result = await myCustomerApi.getMyCustomer(getAll: true);

  //   final value = switch (result) {
  //     Success(value: final accessToken) => accessToken,
  //     Failure(exception: final exception) => exception,
  //   };

  //   if (!AppValid.isNetWork(value)) {
  //   } else if (value is Exception) {
  //   } else {
  //     myCustomer = value as List<MyCustomerModel>;
  //   }
  //   notifyListeners();
  // }

  // Future<void> changeValueService(List<RadioModel> value) async {
  //   selectedService.clear();
  //   selectedService = value;
  //   notifyListeners();
  // }

  // Future<void> setServiceId() async {
  //   serviceId.clear();
  //   if (selectedService.isNotEmpty) {
  //     selectedService.forEach((element) {
  //       serviceId.add(element.id!);
  //     });
  //   }
  //   notifyListeners();
  // }

  // Future<void> removeService(int index) async {
  //   selectedService.removeAt(index);
  //   notifyListeners();
  // }

  // Future<void> initMapCustomer() async {
  //   myCustomer.forEach((element) {
  //     mapPhone.addAll(
  //       {element.id!: '${element.phoneNumber}/${element.fullName}'},
  //     );
  //   });
  //   isLoading=false;
  //   notifyListeners();
  // }

  // Future<void> setLoading()async{
  //   isLoading=true;
  //   notifyListeners();
  // }

  // Future<void> initMapService() async {
  //   myService.forEach((element) {
  //     mapService.addAll(
  //       {
  //         element.id!:
  //             ' ${element.name}/${AppCurrencyFormat.formatMoneyVND(element.money!)} ',
  //       },
  //     );
  //   });
  //   notifyListeners();
  // }

  // Future<void> setNameCustomer(MapEntry<dynamic, dynamic> value) async {
  //   phoneController.text = value.value;
  //   nameController.text = myCustomer
  //       .where((element) => element.id == value.key)
  //       .first
  //       .fullName
  //       .toString();
        
  //   myCustomerId = value.key;

  //   notifyListeners();
  // }

  // Future<void> clearTotal() async {
  //   updatedTotalCost = 0;
  //   totalCost = 0;
  //   totalController.clear();
  //   notifyListeners();
  // }

  // Future<void> calculateTotalPriceByName({bool isCalculate = false}) async {
  //   await clearTotal();
  //   myService.forEach((element) {
  //     serviceId.forEach((elementId) {
  //       if (element.id == elementId) {
  //         updatedTotalCost += element.money!;
  //       }
  //     });
  //     totalCost = updatedTotalCost;
  //     final totalPriceT = AppCurrencyFormat.formatMoneyVND(totalCost);
  //     totalController.text = totalPriceT;
  //     moneyController.text = totalPriceT;
  //   });
  //   totalDiscount();
  //   notifyListeners();
  // }

  // void totalDiscount() {
  //   final moneyText = discountController.text;

  //   final moneyInt = moneyText != '' ? double.parse(moneyText) : 0;

  //   final totalCostDiscount = totalCost - (totalCost * (moneyInt / 100));

  //   final totalPriceT = AppCurrencyFormat.formatMoneyVND(totalCostDiscount);

  //   totalController.text = totalPriceT;

  //   notifyListeners();
  // }

  Future<void> updateDateTime(DateTime time) async {
    dateTime = time;
    notifyListeners();
  }

  Future<void> updateTime(DateTime times) async {
    time = times;
    notifyListeners();
  }

  void checkNoteInput() {
    if (noteController.text.isEmpty) {
      onNote = false;
      noteErrorMsg = ServiceAddLanguage.emptyDescriptionError;
    } else {
      noteErrorMsg = '';
      onNote = true;
    }
    notifyListeners();
  }

  void validPrice(String? value) {
    if (value == null || value.isEmpty) {
      messageErrorPrice = PaymentLanguage.emptyMoneyError;
    } else {
      messageErrorPrice = null; 
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

  // void validAddress(String value) {
  //   if (addressController.text.isEmpty) {
  //     addressMsg = BookingLanguage.emptyAddress;
  //   } else {
  //     addressMsg = '';
  //   }
  //   notifyListeners();
  // }

  // void checkDiscountInput(String value) {
  //   final number = double.tryParse(value);

  //   if (value.isEmpty) {
  //     discountErrorMsg = '';
  //   } else if (onlySpecialChars.hasMatch(value)) {
  //     discountErrorMsg = BookingLanguage.onlySpecialChars;
  //   } else if (number == null || number < 0 || number > 100) {
  //     discountErrorMsg = BookingLanguage.numberBetween;
  //   } else {
  //     discountErrorMsg = '';
  //   }
  //   notifyListeners();
  // }

  void enableConfirmButton() {
    if (messageErrorPrice==null && 
      moneyController.text.trim()!='' && categoryId!=null) {
      enableButton = true;
    } else {
      enableButton = false;
    }
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


  Future<void> onServiceList(BuildContext context) =>
      Navigator.pushNamed(context, Routers.serviceList);

  Future<void> goToHome() => Navigator.pushReplacementNamed(
        context,
        Routers.home,
      );

  dynamic showDialogSuccess(_) {
    showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          content: BookingLanguage.paymentSuccess,
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
          leftButtonName: SignUpLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: BookingLanguage.home,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () {
            goToHome();
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
        return WarningDialog(
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
        );
      },
    );
  }

   dynamic showSuccessDialog(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.success,
          onTap: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void clearData(){
    selectedCategory=0;
    categoryId=listCategory[0].id;
    isButtonSpending=false;
    phoneController.text='';
    nameController.text='';
    addressController.text='';
    noteController.text='';
    moneyController.text='';
    updateDateTime(DateTime.now());
    listCategory=listCategoryIncome;
    notifyListeners();
  }

  void closeDialog(BuildContext context) {
    timer= Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  DateTime date= DateTime.now();

  String setDateTime(){
    final time= '${date.hour}:${date.minute}';
    final day='${date.day}/${date.month}/${date.year}';
    return '$time $day';
  }

  void setDataCategory(){
    listCategoryExpense.clear();
    listCategoryIncome.clear();
    listCategory.forEach((element) {
      if(element.income!){
        listCategoryIncome.add(element);
      }else{
        listCategoryExpense.add(element);
      }
    });
    listCategory=listCategoryIncome;
    notifyListeners();
  }

  Future<void> checkCustomer()async{
    if(phoneController.text.trim()=='' && nameController.text.trim()==''){
      await postBooking();
    }else{
      await postCustomer();
    }
    notifyListeners();
  }

  Future<void> postCustomer() async {
    final result = await myCustomerApi.postMyCustomer(
      MyCustomerParams(
        phoneNumber: phoneController.text.trim(),
        fullName: nameController.text.trim(),
      ),
    );

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      await showDialogNetwork(context);
    } else if (value is Exception) {
    } else {
      myCustomerModel=value as MyCustomerModel;
      myCustomerId=myCustomerModel?.id;
      await postBooking();
    }
    notifyListeners();
  }

  Future<void> postBooking() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await bookingApi.postBooking(MyBookingPramsApi(
      // myServices: serviceId,
      myCustomerId: myCustomerId,
      idCategory: categoryId,
      money: int.parse(moneyController.text.replaceAll(',', '')),
      date: '${dateTime.toString().split(' ')[0]} ${AppDateUtils.formatTimeToHHMM(time)}',
      address: addressController.text=='' ? ''
        :addressController.text.trim(),
      isBooking: false,
      isIncome: isButtonSpending? false: true,
      note: noteController.text == '' ? '' : noteController.text,
      isReminder: null,
    ),);

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      await showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      await showErrorDialog(context);
    } else {
      listMyBooking=value as List<MyBookingModel>;
      await postInvoice(listMyBooking[0].id!, listMyBooking[0].date!);
    }
    notifyListeners();
  }

  Future<void> getCategory() async {
    final result = await categoryApi.getListCategory(null);

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading=false;
      await showDialogNetwork(context);
    } else if (value is Exception) {
      isLoading=true;
    } else {
      isLoading=false;
      listCategory=value as List<CategoryModel>;
      setDataCategory();
    }
    notifyListeners();
  }

  Future<void> postInvoice(int id, String date) async {
    final result = await invoiceApi.postInvoice(InvoiceParams(
      id: id, date: date,));

    final value = switch (result) {
      Success(value: final isBool) => isBool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      LoadingDialog.hideLoadingDialog(context);
      showDialogNetwork(context);
    } else if (value is Exception) {
      LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      await putStatusAppointment(id, 'Done');
    }
    notifyListeners();
  }

  Future<void> putStatusAppointment(int id, String status) async {
    final result = await myBookingApi.putStatusAppointment(
      MyBookingParams(
        id: id,
        status: status,
      ),
    );

    final value = switch (result) {
      Success(value: final bool) => bool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
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

  @override
  void dispose() {
    timer?.cancel();
    phoneController.dispose();
    nameController.dispose();
    addressController.dispose();
    noteController.dispose();
    moneyController.dispose();
    super.dispose();
  }
}
