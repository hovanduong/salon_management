// ignore_for_file: lines_longer_than_80_chars, avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';

import '../../resource/service/booking.dart';
import '../../resource/service/category_api.dart';
import '../../resource/service/my_customer_api.dart';
import '../../utils/app_currency.dart';
import '../../utils/app_valid.dart';
import '../../utils/date_format_utils.dart';
import '../base/base.dart';

import '../routers.dart';

class BookingViewModel extends BaseViewModel {
  BookingApi bookingApi = BookingApi();
  MyCustomerApi myCustomerApi = MyCustomerApi();
  CategoryApi categoryApi= CategoryApi();

  // List<int>? myServiceId = [];
  // List<int> serviceId = [];
  // List<RadioModel> selectedService = [];
  List<MyServiceModel> myService = [];
  List<MyCustomerModel> myCustomer = [];
  List<CategoryModel> listCategory = [];
  List<String> listImageCategory=[
    AppImages.icBodyMassage,
    AppImages.icNailCare,
    AppImages.eyelash,
    AppImages.makeHair,
    AppImages.icSkinTreatment,
    AppImages.makeUp,
    AppImages.tattoo,
  ];

  int? myCustomerId;
  int? index;
  int? categoryId;

  // num totalCost = 0;
  // num totalPrice = 0;
  // num updatedTotalCost = 0;

  DateTime dateTime = DateTime.now();
  // DateTime dateTime = DateTime.now();

  MyBookingModel? dataMyBooking;
  MyCustomerModel? myCustomerModel;


  Map<int, String> mapService = {};
  Map<int, String> mapPhone = {};

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  // final totalController = TextEditingController();
  // final timeController = TextEditingController();
  // TextEditingController discountController = TextEditingController();

  DateRangePickerController dateController = DateRangePickerController();

  bool onAddress = true;
  bool onPhone = true;
  bool onTopic = true;
  bool onMoney = true;
  bool onTime = true;
  bool onNote = true;
  bool onDiscount = true;
  bool isListViewVisible = false;
  bool enableButton = false;
  bool isLoading=true;
  bool isShowAll=false;

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

  Future<void> init(MyBookingModel? myBookingModel) async {
    await getCategory();
    categoryId=listCategory[0].id;
    await setDataMyBooking(myBookingModel);
    // selectedCategory=0;
    // await fetchService();
    // await fetchCustomer();
    // await initMapCustomer();
    // await initMapService();
    notifyListeners();
  }

  Future<void> goToAddCategory(BuildContext context) async {
    await Navigator.pushNamed(context, Routers.addCategory,);
    await init(null);
  } 

  Future<void> setDataMyBooking(MyBookingModel? myBookingModel) async {
    if (myBookingModel != null) {
      dataMyBooking = myBookingModel;
      phoneController.text = dataMyBooking?.myCustomer?.phoneNumber??'';
      nameController.text = dataMyBooking?.myCustomer?.fullName??'';
      addressController.text = dataMyBooking?.address??'';
      noteController.text = dataMyBooking?.note ??'';
      moneyController.text=AppCurrencyFormat.formatMoney(dataMyBooking!.money);
      categoryId= myBookingModel.category?.id;
      myCustomerId=myBookingModel.myCustomer?.id;
      dateTime = DateTime.parse(
        AppDateUtils.formatDateLocal(
          dataMyBooking!.date!,
        ),
      );
      // setSelectedService();
      // await setServiceId();
      // await fetchService();
      // await calculateTotalPriceByName();
      enableConfirmButton();
    }
    notifyListeners();
  }

  void setCategorySelected(int index){
    if(index==16 || index ==17){
      isShowAll=!isShowAll;
    }else{
      // selectedCategory=index;
      categoryId=listCategory[index].id;
    }
    enableConfirmButton();
    notifyListeners();
  }

  // void setSelectedService() {
  //   if (dataMyBooking!.myServices!.isNotEmpty) {
  //     dataMyBooking?.myServices!.forEach((service) {
  //       selectedService.add(
  //         RadioModel(
  //           isSelected: true,
  //           id: service.id,
  //           name: '${service.name}/${currencyFormatter.format(service.money)}',
  //         ),
  //       );
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

  // void setLoading(bool loading){
  //   isLoading=loading;
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

  // Future<void> initMapService() async {
  //   myService.forEach((element) {
  //     mapService.addAll(
  //       {
  //         element.id!:
  //             ' ${element.name}/${currencyFormatter.format(element.money)} ',
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
  //     final totalPriceT = currencyFormatter.format(totalCost);
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

  //   final totalPriceT = currencyFormatter.format(totalCostDiscount);

  //   totalController.text = totalPriceT;

  //   notifyListeners();
  // }

  Future<void> updateDateTime(DateTime time) async {
    dateTime = time;
    notifyListeners();
  }

  // void checkNoteInput() {
  //   if (noteController.text.isEmpty) {
  //     onNote = false;
  //     noteErrorMsg = ServiceAddLanguage.emptyDescriptionError;
  //   } else {
  //     noteErrorMsg = '';
  //     onNote = true;
  //   }
  //   notifyListeners();
  // }

  // void validAddress(String value) {
  //   if (addressController.text.trim().isEmpty) {
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

  Future<void> checkDataExist()async{
    if(dataMyBooking!=null){
      await putBooking();
    }else{
      await postCustomer(); 
    }
  }

  // Future<void> checkCustomer()async{
  //   if(phoneController.text.trim()=='' && nameController.text.trim()==''){
  //     await checkDataExist();
  //   }else{
  //     await postCustomer();
  //   }
  //   notifyListeners();
  // }

  void validPrice(String? value) {
    money = value;
    if (value == null || value.isEmpty) {
      messageErrorPrice = ServiceAddLanguage.emptyMoneyError;
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

  void enableConfirmButton() {
    if (messageErrorPrice==null && 
      moneyController.text.trim()!='' && categoryId!=null) {
      enableButton = true;
    } else {
      enableButton = false;
    }
    notifyListeners();
  }

  Future<void> onServiceList(BuildContext context) =>
      Navigator.pushNamed(context, Routers.serviceList);

  Future<void> goToBooking() => Navigator.pushReplacementNamed(
        context,
        Routers.home,
        arguments: 2,
      );

  dynamic showDialogSuccess(_, String title) {
    showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          image: AppImages.icCheck,
          title: title,
          leftButtonName: SignUpLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: BookingLanguage.booking,
          onTapLeft: () {
            Navigator.pop(context);
          },
          onTapRight: () {
            goToBooking();
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

  void closeDialog(BuildContext context) {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  void clearData() {
    // serviceId.clear();
    // selectedService.clear();
    // totalController.clear();
    // discountController.text = '';
    categoryId=null;
    dateTime = DateTime.now();
    phoneController.text = '';
    moneyController.text = '';
    nameController.text = '';
    addressController.clear();
    noteController.clear();
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

  Future<void> getCategory() async {
    final result = await categoryApi.getListCategory(1, '');

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
    }
    notifyListeners();
  }

  Future<void> postBooking() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await bookingApi.postBooking(
      MyBookingPramsApi(
        myCustomerId: myCustomerId,
        idCategory: categoryId,
        money: int.parse(moneyController.text.replaceAll(',', '')),
        date: dateTime.toString().trim(),
        address: addressController.text.trim(),
        isBooking: true,
        isIncome: false,
        note: noteController.text.trim(),
      ),
    );

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
      LoadingDialog.hideLoadingDialog(context);
      clearData();
      await showDialogSuccess(context, BookingLanguage.bookingSuccess);
    }
    notifyListeners();
  }

  Future<void> putBooking() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await bookingApi.putBooking(
      MyBookingPramsApi(
        id: dataMyBooking?.id,
        address: addressController.text.trim(),
        date: AppDateUtils.formatDateTT(dateTime.toString().trim()),
        phoneNumber: phoneController.text.trim(),
        name: nameController.text.trim(),
        myCustomerId: myCustomerId,
        idCategory: categoryId,
        note: noteController.text.trim(),
        money: int.parse(moneyController.text.replaceAll(',', '')),
      ),
    );

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
      LoadingDialog.hideLoadingDialog(context);
      await showDialogSuccess(context, BookingLanguage.updateBookingSuccess);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    moneyController.dispose();
    phoneController.dispose();
    nameController.dispose();
    addressController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
