// ignore_for_file: lines_longer_than_80_chars, cast_nullable_to_non_nullable, avoid_bool_literals_in_conditional_expressions, use_if_null_to_convert_nulls_to_bools

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
  CategoryApi categoryApi = CategoryApi();
  MyCustomerApi myCustomerApi = MyCustomerApi();
  MyBookingApi myBookingApi = MyBookingApi();
  InvoiceApi invoiceApi = InvoiceApi();

  List<int>? myServiceId = [];
  List<int> serviceId = [];
  List<int> listMoney = [];

  List<MyBookingModel> listMyBooking = [];
  List<CategoryModel> listCategory = [];
  List<CategoryModel> listCategoryIncome = [];
  List<CategoryModel> listCategoryExpense = [];

  Timer? timer;

  int? myCustomerId;
  int? selectedCategory;
  int? categoryId;
  int? idUser;

  DateTime dateTime = DateTime.now();
  DateTime time = DateTime.now();

  MyBookingModel? dataMyBooking;
  MyCustomerModel? myCustomerModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  DateRangePickerController dateController = DateRangePickerController();

  bool onNote = true;
  bool isListViewVisible = false;
  bool enableButton = false;
  bool isLoading = true;
  bool isButtonSpending = false;
  bool isShowAll = false;
  bool isShowCase = true;
  bool isShowButton = true;

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

  List<FocusNode> listFocus = List.generate(5, (index) => FocusNode());

  GlobalKey keyInfoCustomer = GlobalKey();
  GlobalKey keyMoney = GlobalKey();
  GlobalKey key = GlobalKey();
  GlobalKey keyAddCategory = GlobalKey();
  GlobalKey keyCategory = GlobalKey();
  GlobalKey keyDateTime = GlobalKey();

  Future<void> init(MyBookingModel? myBookingModel) async {
    idUser = int.parse(await AppPref.getDataUSer('id') ?? '0');
    await getCategory();
    selectedCategory = 0;
    categoryId = listCategory[0].id;
    isButtonSpending = false;
    await setDataMyBooking(myBookingModel);
    await setShowButton();
    await AppPref.getShowCase('showCasePayment$idUser').then(
      (value) => isShowCase = value ?? true,
    );
    startShowCase();
    await hideShowcase();
    notifyListeners();
  }

  Future<void> hideShowcase() async {
    await AppPref.setShowCase('showCasePayment$idUser', false);
    isShowCase = false;
    notifyListeners();
  }

  void startShowCase() {
    if (isShowCase) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowCaseWidget.of(context).startShowCase(
          [
            keyInfoCustomer,
            keyMoney,
            key,
            keyAddCategory,
            keyCategory,
            keyDateTime
          ],
        );
      });
    }
  }

  Future<void> goToBill(BuildContext context) => Navigator.pushNamed(
        context,
        Routers.bill,
        arguments: listMyBooking[0],
      );

  Future<void> goToAddCategory(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      Routers.addCategory,
    );
    await init(null);
  }

  Future<void> setDataMyBooking(MyBookingModel? myBookingModel) async {
    if (myBookingModel != null) {
      dataMyBooking = myBookingModel;
      isButtonSpending =
          (myBookingModel.income != null && myBookingModel.income == true)
              ? false
              : true;
      phoneController.text = dataMyBooking?.myCustomer?.phoneNumber ?? '';
      nameController.text = dataMyBooking?.myCustomer?.fullName ?? '';
      addressController.text = dataMyBooking?.address ?? '';
      noteController.text = dataMyBooking?.note ?? '';
      moneyController.text = dataMyBooking?.money != null
          ? AppCurrencyFormat.formatMoney(dataMyBooking?.money)
          : '';
      categoryId = myBookingModel.category?.id;
      myCustomerId = myBookingModel.myCustomer?.id;
      dateTime = DateTime.parse(
        AppDateUtils.formatDateLocal(
          dataMyBooking!.date!,
        ),
      );
      time = dateTime;
      enableConfirmButton();
    }
    notifyListeners();
  }

  void setButtonSelect(String name) {
    if (name == PaymentLanguage.income) {
      categoryId = listCategoryIncome[0].id;
      listCategory = listCategoryIncome;
      isButtonSpending = false;
    } else {
      listCategory = listCategoryExpense;
      categoryId = listCategoryExpense[0].id;
      isButtonSpending = true;
    }
    isShowAll = false;
    selectedCategory = 0;
    notifyListeners();
  }

  void setCategorySelected(int index) {
    if (index == 16 || index == 17) {
      isShowAll = !isShowAll;
    } else {
      selectedCategory = index;
      categoryId = listCategory[index].id;
    }
    enableConfirmButton();
    notifyListeners();
  }

  Future<void> setShowButton() async {
    listFocus.forEach((node) {
      node.addListener(() {
        isShowButton = !listFocus.any((focus) => focus.hasFocus);
        notifyListeners();
      });
    });
  }

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

  void enableConfirmButton() {
    if (messageErrorPrice == null &&
        moneyController.text.trim() != '' &&
        categoryId != null) {
      enableButton = true;
    } else {
      enableButton = false;
    }
    notifyListeners();
  }

  void setMoneyInput(int index) {
    moneyController.text = AppCurrencyFormat.formatMoney(listMoney[index]);
    validPrice(moneyController.text);
    listMoney = [];
    notifyListeners();
  }

  void setShowRemind(String value) {
    if (value.length > 3 || value == '') {
      listMoney = [];
    } else {
      listMoney = [];
      for (var i = 0; i < 3; i++) {
        listMoney.add(
          int.parse(
              '$value${i == 0 ? '000' : i == 1 ? '0000' : i == 2 ? '00000' : '0'}'),
        );
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

  void clearData() {
    selectedCategory = 0;
    listMoney = [];
    categoryId = listCategory[0].id;
    isButtonSpending = false;
    phoneController.text = '';
    nameController.text = '';
    addressController.text = '';
    noteController.text = '';
    moneyController.text = '';
    // updateDateTime(DateTime.now());
    listCategory = listCategoryIncome;
    notifyListeners();
  }

  dynamic showSuccessEdit(_) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        closeDialog(context);
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.successEdit,
        );
      },
    );
    timer = Timer(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  void closeDialog(BuildContext context) {
    timer = Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  DateTime date = DateTime.now();

  String setDateTime() {
    final time = '${date.hour}:${date.minute}';
    final day = '${date.day}/${date.month}/${date.year}';
    return '$time $day';
  }

  void setDataCategory() {
    listCategoryExpense.clear();
    listCategoryIncome.clear();
    listCategory.forEach((element) {
      if (element.income!) {
        listCategoryIncome.add(element);
      } else {
        listCategoryExpense.add(element);
      }
    });
    listCategory = listCategoryIncome;
    notifyListeners();
  }

  Future<void> checkCustomer() async {
    if (dataMyBooking != null) {
      await putBooking();
    } else {
      if (phoneController.text.trim() == '' &&
          nameController.text.trim() == '') {
        await postBooking();
      } else {
        await postCustomer();
      }
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
      myCustomerModel = value as MyCustomerModel;
      myCustomerId = myCustomerModel?.id;
      await postBooking();
    }
    notifyListeners();
  }

  Future<void> postBooking() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await bookingApi.postBooking(
      MyBookingPramsApi(
        // myServices: serviceId,
        myCustomerId: myCustomerId,
        idCategory: categoryId,
        money: int.parse(moneyController.text.replaceAll(',', '')),
        date: AppDateUtils.formatDateTT(
          '${dateTime.toString().split(' ')[0]} ${time.toString().split(' ')[1]}',
        ),
        address:
            addressController.text == '' ? '' : addressController.text.trim(),
        isBooking: false,
        isIncome: isButtonSpending ? false : true,
        note: noteController.text == '' ? '' : noteController.text,
        isReminder: null,
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
      listMyBooking = value as List<MyBookingModel>;
      await postInvoice(listMyBooking[0].id!, listMyBooking[0].date!);
    }
    notifyListeners();
  }

  Future<void> putBooking() async {
    LoadingDialog.showLoadingDialog(context);
    final result = await bookingApi.putBooking(
      MyBookingPramsApi(
        id: dataMyBooking?.id,
        address:
            addressController.text == '' ? '' : addressController.text.trim(),
        date: AppDateUtils.formatDateTT(
          '${dateTime.toString().split(' ')[0]} ${time.toString().split(' ')[1]}',
        ),
        phoneNumber:
            phoneController.text == '' ? '' : phoneController.text.trim(),
        name: nameController.text != '' ? nameController.text.trim() : '',
        myCustomerId: myCustomerId,
        idCategory: categoryId,
        note: noteController.text == '' ? '' : noteController.text.trim(),
        isIncome: isButtonSpending ? false : true,
        money: moneyController.text != ''
            ? int.parse(moneyController.text.replaceAll(',', ''))
            : null,
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

  Future<void> getCategory() async {
    final result = await categoryApi.getListCategory(null);

    final value = switch (result) {
      Success(value: final listCategory) => listCategory,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading = false;
      await showDialogNetwork(context);
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      listCategory = value as List<CategoryModel>;
      setDataCategory();
    }
    notifyListeners();
  }

  Future<void> postInvoice(int id, String date) async {
    final result = await invoiceApi.postInvoice(InvoiceParams(
      id: id,
      date: date,
    ));

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
