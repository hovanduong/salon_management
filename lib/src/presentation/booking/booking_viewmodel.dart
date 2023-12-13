// ignore_for_file: lines_longer_than_80_chars, avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';

import '../../resource/service/booking.dart';
import '../../resource/service/category_api.dart';
import '../../resource/service/income_api.dart';
import '../../resource/service/my_booking.dart';
import '../../resource/service/my_customer_api.dart';
import '../../resource/service/notification_api.dart';
import '../../utils/app_currency.dart';
import '../../utils/app_valid.dart';
import '../../utils/date_format_utils.dart';
import '../../utils/utils.dart';
import '../base/base.dart';

import '../routers.dart';

class BookingViewModel extends BaseViewModel {
  BookingApi bookingApi = BookingApi();
  MyCustomerApi myCustomerApi = MyCustomerApi();
  CategoryApi categoryApi= CategoryApi();
  MyBookingApi myBookingApi = MyBookingApi();
  NotificationApi notificationApi= NotificationApi();

  // List<int>? myServiceId = [];
  // List<int> serviceId = [];
  // List<RadioModel> selectedService = [];
  List<MyServiceModel> myService = [];
  List<MyCustomerModel> myCustomer = [];
  List<CategoryModel> listCategory = [];
  List<int> listMoney = [];
  List<String> listImageCategory=[
    AppImages.icBodyMassage,
    AppImages.icNailCare,
    AppImages.eyelash,
    AppImages.makeHair,
    AppImages.icSkinTreatment,
    AppImages.makeUp,
    AppImages.tattoo,
  ];
  List<FocusNode> listFocus= List.generate(5, (index) => FocusNode());

  int? myCustomerId;
  int? index;
  int? categoryId;

  // num totalCost = 0;
  // num totalPrice = 0;
  // num updatedTotalCost = 0;

  DateTime dateTime = DateTime.now();
  DateTime time = DateTime.now();

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
  bool enableButton = true;
  bool isLoading=true;
  bool isShowAll=false;
  bool isShowCase=true;
  bool isShowButton=true;

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

  Timer? timer;

  GlobalKey keyInfoCustomer= GlobalKey();
  GlobalKey keyMoney= GlobalKey();
  GlobalKey keyAddCategory= GlobalKey();
  GlobalKey keyCategory= GlobalKey();
  GlobalKey keyDateTime= GlobalKey();

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
    await setShowButton();
    await AppPref.getShowCase('showCaseBooking').then(
      (value) => isShowCase=value??true,);
    startShowCase();
    await hideShowcase();
    notifyListeners();
  }

  Future<void> hideShowcase() async{
    await AppPref.setShowCase('showCaseBooking', false);
    isShowCase=false;
    notifyListeners();
  }

  void startShowCase(){
    if(isShowCase){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowCaseWidget.of(context).startShowCase(
          [keyInfoCustomer, keyAddCategory, keyCategory, keyDateTime],
        );
      });
    }
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

  Future<void> setShowButton() async{
    listFocus.forEach((node) {
      node.addListener(() {
        isShowButton = !listFocus.any((focus) => focus.hasFocus);
        notifyListeners();
      });
    });
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
      time=dateTime;
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

  Future<void> updateTime(DateTime times) async {
    time = times;
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
      await getCancelRemind(
        NotificationParams(id: dataMyBooking?.id, isRemind: false),);
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
    if (value == null || value.isEmpty) {
      messageErrorPrice = BookingLanguage.emptyMoneyError;
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
    if (categoryId!=null) {
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
        arguments: const IncomeParams(page: 2),
      );

  dynamic showDialogSuccess(_, String title) {
    showDialog(
      context: context,
      builder: (_) {
        return WarningDialog(
          image: AppImages.icCheck,
          title: title,
          leftButtonName: SignUpLanguage.close,
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

  dynamic showSuccessEdit(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.successUpdate,
        );
      },
    );
    timer= Timer(const Duration(seconds: 2), () {Navigator.pop(context);});
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
    listMoney=[];
    categoryId=null;
    dateTime = DateTime.now();
    time= DateTime.now();
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
    }
    notifyListeners();
  }

  Future<void> postBooking() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await bookingApi.postBooking(
      MyBookingPramsApi(
        myCustomerId: myCustomerId,
        idCategory: categoryId,
        money: moneyController.text!=''?
         int.parse(moneyController.text.replaceAll(',', '')): null,
        date: AppDateUtils.formatDateTT(
          '${dateTime.toString().split(' ')[0]} ${time.toString().split(' ')[1]}',),
        address: addressController.text.trim(),
        isBooking: true,
        isIncome: true,
        note: noteController.text.trim(),
        isReminder: false,
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
        date: AppDateUtils.formatDateTT(
          '${dateTime.toString().split(' ')[0]} ${time.toString().split(' ')[1]}',
        ),
        phoneNumber: phoneController.text.trim(),
        name: nameController.text.trim(),
        myCustomerId: myCustomerId,
        idCategory: categoryId,
        note: noteController.text.trim(),
        money: moneyController.text!=''?
         int.parse(moneyController.text.replaceAll(',', '')): null,
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
      await showSuccessEdit(context);
    }
    notifyListeners();
  }

  Future<void> getCancelRemind(NotificationParams params) async {
    // LoadingDialog.showLoadingDialog(context);
    final result = await notificationApi.getCancelRemind(params.idBooking??0);

    final value = switch (result) {
      Success(value: final bool) => bool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      // LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      // LoadingDialog.hideLoadingDialog(context);
      
      await putRemindBooking(params.idBooking??0, params.isRemind);
    }
    notifyListeners();
  }

  Future<void> putRemindBooking(int id, bool isRemind) async {
    // LoadingDialog.showLoadingDialog(context);
    final result = await myBookingApi.putRemindBooking(
      MyBookingParams(
        id: id,
        isRemind: isRemind,
      ),
    );

    final value = switch (result) {
      Success(value: final bool) => bool,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      showDialogNetwork(context);
    } else if (value is Exception) {
      // LoadingDialog.hideLoadingDialog(context);
      showErrorDialog(context);
    } else {
      // LoadingDialog.hideLoadingDialog(context);
      // // showSuccessDiaglog(context);
      // await fetchData();
    }
    notifyListeners();
  }


  @override
  void dispose() {
    timer?.cancel();
    moneyController.dispose();
    phoneController.dispose();
    nameController.dispose();
    addressController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
