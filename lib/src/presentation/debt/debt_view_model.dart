import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/language/debt_language.dart';
import '../../resource/model/model.dart';
import '../../resource/service/owes_invoice_api.dart';
import '../../utils/app_currency.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class DebtViewModel extends BaseViewModel{

  bool isLoading=true;
  bool isShowOwes=true;
  bool isShowCase=false;

  OwesInvoiceApi owesInvoiceApi= OwesInvoiceApi();

  GlobalKey keyAddDebt= GlobalKey();
  GlobalKey keyNote= GlobalKey();
  GlobalKey keyOwes= GlobalKey();
  GlobalKey keyHistory= GlobalKey();

  MyCustomerModel? myCustomerModel;
  OwesTotalModel? owesTotalModel;

  List<OwesModel> listOwesMe=[];
  List<OwesModel> listOwesUser=[];
  List<OwesModel> listOwes=[];

  TabController? tabController;

  String? messageOwes;

  int page=1;

  Future<void> init(MyCustomerModel? params, {dynamic dataThis}) async{
    tabController=TabController(length: 2, vsync: dataThis);
    myCustomerModel=params;
    await fetchDataOwes();
    await AppPref.getShowCase('showCaseDebt').then(
      (value) => isShowCase=value??true,);
    startShowCase();
    await hideShowcase();
    notifyListeners();
  }

  Future<void> hideShowcase() async {
    await AppPref.setShowCase('showCaseDebt', false);
    isShowCase = false;
    notifyListeners();
  }

  void startShowCase() {
    if (isShowCase == true) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        return ShowCaseWidget.of(context).startShowCase(
          [keyAddDebt, keyNote, keyOwes, keyHistory],
        );
      });
    }
  }

  Future<void> fetchDataOwes()async{
    page=1;
    await getOwesInvoice(page, 1);
    listOwesMe=listOwes;
    await getOwesTotal();
    checkOwes();
    notifyListeners();
  }

  Future<void> changeTab(int tab)async{
    // print(tab);
    listOwes.clear();
    isLoading=true;
    if(tab==0){
      await getOwesInvoice(page, 1);
      listOwesMe=listOwes;
    }else{
      await getOwesInvoice(page, 0);
      listOwesUser=listOwes;
    }
    notifyListeners();
  }

  Future<void> goToDebtAdd()async {
    final data = myCustomerModel;
    data?.isMe= owesTotalModel?.isMe;
    data?.isUser=owesTotalModel?.isUser;
    data?.money= (owesTotalModel?.isMe??false)? (owesTotalModel?.oweMe??0)
      : (owesTotalModel?.oweUser??0);
    await Navigator.pushNamed(context, 
      Routers.debtAdd, arguments: data,);
  }

  void checkOwes(){
    final myMoney=  (owesTotalModel?.oweMe??0)- (owesTotalModel?.paidMe??0);
    final yourMoney=  (owesTotalModel?.oweUser??0)- (owesTotalModel?.paidUser??0);
    if(owesTotalModel?.isMe??false){
      messageOwes='${DebtLanguage.amountOfMoney} ${DebtLanguage.my} ${
      DebtLanguage.yourOwes}: ${AppCurrencyFormat.formatMoneyVND(myMoney)}';
    }else if(owesTotalModel?.isUser??false){
      messageOwes='${DebtLanguage.amountOfMoney} ${
      myCustomerModel?.fullName} ${DebtLanguage.yourOwes}: ${
        AppCurrencyFormat.formatMoneyVND(yourMoney)}';
    }else{
      messageOwes='0';
    }
    notifyListeners();
  }

  Future<void> pullRefresh()async{
    isLoading=true;
    await fetchDataOwes();
    notifyListeners();
  }

  void showOwes(){
    isShowOwes=!isShowOwes;
    notifyListeners();
  }

  dynamic showDialogNote(_,) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WarningOneDialog(
          image: AppImages.icCheck,
          title: SignUpLanguage.note,
          content: DebtLanguage.contentEmptyNameDebit,
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

  Future<void> getOwesInvoice(int page, int isGet) async {
    final result = await owesInvoiceApi.getOwesInvoice(
      OwesInvoiceParams(
        page: page,
        id: myCustomerModel?.id,
        isGetMe: isGet,
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
      listOwes = value as List<OwesModel>;
      isLoading=false;
    }
    notifyListeners();
  }

  Future<void> getOwesTotal() async {
    final result = await owesInvoiceApi.getTotalOwesInvoice(
      OwesInvoiceParams(
        id: myCustomerModel?.id,
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
      owesTotalModel = value as OwesTotalModel;
      isLoading=false;
    }
    notifyListeners();
  }
}
