import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/language/debit_language.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/model/model.dart';
import '../../resource/service/debit_api.dart';
import '../../resource/service/total_debt_api.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class DebtorViewModel extends BaseViewModel{

  bool isLoading=true;
  bool loadingMore=false;
  bool isShowCase=false;

  GlobalKey keyAdd= GlobalKey();
  GlobalKey keySearch= GlobalKey();

  DebitApi debitApi= DebitApi();
  TotalDebitApi totalDebitApi = TotalDebitApi();

  int page=1;
  int? idUser;

  Timer? timer;

  TextEditingController nameController= TextEditingController();
  TextEditingController searchController= TextEditingController();

  List<MyCustomerModel> listCustomer=[];
  List<MyCustomerModel> listCurrent=[];

  ScrollController scrollController= ScrollController();

  Future<void> init() async{
    idUser = int.parse(await AppPref.getDataUSer('id') ?? '0');
    await fetchData();
    await AppPref.getShowCase('showCaseDebtor$idUser').then(
      (value) => isShowCase = value ?? true,
    );
    startShowCase();
    await hideShowcase();
  }

  Future<void> fetchData()async{
    page=1;
    await getDebit(page, '');
    listCurrent=listCustomer;
    scrollController.addListener(scrollListener);
    notifyListeners();
  }

  Future<void> hideShowcase() async {
    await AppPref.setShowCase('showCaseDebtor$idUser', false);
    isShowCase = false;
    notifyListeners();
  }

  void startShowCase() {
    if (isShowCase == true) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        return ShowCaseWidget.of(context).startShowCase(
          [keyAdd, keySearch,],
        );
      });
    }
  }

  Future<void> goToDebt({MyCustomerModel? myCustomerModel,})async{
    await Navigator.pushNamed(context, 
      Routers.debt, arguments: myCustomerModel,);
    await fetchData();
  }

  Future<void> pullRefresh() async {
    listCurrent.clear();
    nameController.clear();
    isLoading = true;
    await init();
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    page += 1;
    await getDebit(page,'');
    listCurrent = [...listCurrent, ...listCustomer];
    notifyListeners();
  }

  dynamic scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
      loadingMore = true;
      Future.delayed(const Duration(seconds: 2), () {
        loadMoreData();
        loadingMore = false;
      });
      notifyListeners();
    }
  }

  Future<void> onSearchDebit(String value) async {
    await getDebit(page,value.trim());
    listCurrent=listCustomer;
    notifyListeners();
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
    await pullRefresh();
  }

  void closeDialog(BuildContext context) {
    timer = Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
    );
  }

  void checkName(String? name){
    if(name!=null){
      nameController.text=name;
    }
    notifyListeners();
  }

  dynamic showDialogAddDebit(_, {int? idEdit, String? name}) {
    checkName(name);
    return showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          hintTextForm: DebitLanguage.nameCustomer,
          content: DebitLanguage.notificationDebit,
          title: idEdit!=null? DebitLanguage.editDebitCustomer
            : DebitLanguage.addDebitCustomer,
          leftButtonName: DebitLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: DebitLanguage.confirm,
          controller: nameController,
          isForm: true,
          onTapLeft: () {
            Navigator.pop(context,);
          },
          onTapRight: () async {
            Navigator.pop(context,);
            if(nameController.text.trim()!=''){
              if(idEdit!=null){
                await putDebit(idEdit);
              }else{
                await postDebit(nameController.text.trim());
              }
            }else{
              showDialogEmptyName(_, idEdit: idEdit);
            }
          },
        );
      },
    );
  }

  dynamic showDialogEmptyName(_, {int? idEdit}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: SignUpLanguage.failed,
          content: DebitLanguage.contentEmptyNameDebit,
          leftButtonName: DebitLanguage.close,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: DebitLanguage.back,
          onTapLeft: () {
            Navigator.pop(context,);
          },
          onTapRight: () async {
            Navigator.pop(context,);
            showDialogAddDebit(_, idEdit: idEdit);
          },
        );
      },
    );
  }

   dynamic showWaningDiaglog({String? title, Function()? onTapRight}) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          image: AppImages.icPlus,
          title: title ?? '',
          leftButtonName: SignUpLanguage.cancel,
          onTapLeft: () {
            Navigator.pop(context);
          },
          rightButtonName: DebitLanguage.confirm,
          onTapRight: () async {
            Navigator.pop(context);
            await onTapRight!();
          },
        );
      },
    );
  }

  Future<void> getDebit(int page, String search) async {
    final result = await debitApi.getDebit(
      DebitParams(
        page: page,
        search: search,
      ),
    );

    final value = switch (result) {
      Success(value: final customer) => customer,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading = true;
    } else if (value is Exception) {
      isLoading = true;
    } else {
      listCustomer = value as List<MyCustomerModel>;
      isLoading=false;
    }
    notifyListeners();
  }

  Future<void> postDebit(String name) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await debitApi.postDebit(DebitParams(
      fullName: name,
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
      showSuccessDiaglog(context);
    }
    notifyListeners();
  }

  Future<void> putDebit(int id) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await debitApi.putDebit(DebitParams(
      fullName: nameController.text.trim(),
      id: id,
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
      showSuccessDiaglog(context);
    }
    notifyListeners();
  }

  Future<void> deleteDebit(int id) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await debitApi.deleteDebit(id);

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
      showSuccessDiaglog(context);
    }
    notifyListeners();
  }
  
  @override
  void dispose() {
    timer?.cancel();
    nameController.dispose();
    super.dispose();
  }
}
