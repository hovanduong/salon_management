import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/language/debt_language.dart';
import '../../configs/widget/basic/infomation_app.dart';
import '../../configs/widget/dialog/dialog_user_manual.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
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
  bool loadingMore = false;

  OwesInvoiceApi owesInvoiceApi= OwesInvoiceApi();

  GlobalKey keyAddDebt= GlobalKey();
  GlobalKey keyNote= GlobalKey();
  GlobalKey keyOwes= GlobalKey();
  GlobalKey keyHistory= GlobalKey();

  MyCustomerModel? myCustomerModel;
  OwesTotalModel? owesTotalModel;

  List<OwesModel> listOwesMe=[];
  List<OwesModel> listOwes=[];
  List<String> listName = [
    DebtLanguage.allTransactions,
    DebtLanguage.myHistory,
  ];

  // TabController? tabController;
  ScrollController scrollControllerMe = ScrollController();

  String? messageOwes;
  String? dropValue;

  int pageMe=1;
  int tabCurrent=0;
  num? moneyRemaining;
  num? moneyPaid;

  Timer? timer;

  Future<void> init(MyCustomerModel? params, {dynamic dataThis}) async{
    // tabController=TabController(length: 2, vsync: dataThis);
    myCustomerModel=params;
    await setDataOwe();
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

  Future<void> setDataOwe()async{
    dropValue=listName.first;
    final name= myCustomerModel!.fullName!.split(' ').last;
    final nameLocal= await AppPref.getDataUSer('get${myCustomerModel?.id}$name');
    if(myCustomerModel!=null){
      listName.add('${DebtLanguage.uHistory} $name');
      if(nameLocal==null ){
        await AppPref.setDataUser('get${myCustomerModel?.id}$name', listName.first);
      }else{
        dropValue=nameLocal;
      }
    }
    notifyListeners();
  }

  Future<void> setData(String value)async{
    final name= myCustomerModel!.fullName!.split(' ').last;
    dropValue= value;
    await AppPref.setDataUser('get${myCustomerModel?.id}$name', value);
    await fetchDataOwes();
    notifyListeners();
  }

  Future<void> fetchDataOwes()async{
    isLoading=true;
    pageMe=1;
    await getOwesTotal();
    if(dropValue==listName[0]){
      await getOwesInvoice(pageMe, 2);
      listOwesMe=listOwes;
    }else if(dropValue==listName[1]){
      await getOwesInvoice(pageMe, 1);
      listOwesMe=listOwes;
    }else{
      await getOwesInvoice(pageMe, 0);
      listOwesMe=listOwes;
    }
    scrollControllerMe.addListener(
      () => scrollListener(scrollControllerMe),
    );
    checkOwes();
    checkMoneyOwe();
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    pageMe += 1;
    if(dropValue==listName[0]){
      await getOwesInvoice(pageMe, 2);
      listOwesMe = [...listOwesMe, ...listOwes];
    }else if(dropValue==listName[1]){
      await getOwesInvoice(pageMe, 1);
      listOwesMe = [...listOwesMe, ...listOwes];
    }else{
      await getOwesInvoice(pageMe, 0);
      listOwesMe = [...listOwesMe, ...listOwes];
    }
    loadingMore=false;
    notifyListeners();
  }

  dynamic scrollListener(ScrollController scrollController) async {
    if (scrollController.position.pixels ==
      scrollController.position.maxScrollExtent &&
        scrollController.position.pixels > 0) {
        loadingMore = true;
      Future.delayed(const Duration(seconds: 2), loadMoreData);
    }
    notifyListeners();
  }

  Future<void> changeTab(int tab)async{
    // print(tab);
    // listOwes.clear();
    isLoading=true;
    tabCurrent=tab;
    if(tab==0){
      await getOwesInvoice(1, 1);
      listOwesMe=listOwes;
    }else{
      await getOwesInvoice(1, 0);
      // listOwesUser=listOwes;
    }
    notifyListeners();
  }

  Future<void> goToDebtDetail(OwesModel owesModel)
    => Navigator.pushNamed(context, Routers.debtDetail, arguments: owesModel,);
  
  Future<void> goToDebtAdd({OwesModel? list})async {
    final data = myCustomerModel;
    final myMoney=  (owesTotalModel?.oweMe??0)- (owesTotalModel?.paidMe??0);
    final yourMoney=  (owesTotalModel?.oweUser??0)- (owesTotalModel?.paidUser??0);
    data?.isMe= owesTotalModel?.isMe;
    data?.isUser=owesTotalModel?.isUser;
    data?.money= (owesTotalModel?.isMe??false)? myMoney: yourMoney;
    data?.owesModel= list;
    await Navigator.pushNamed(context, 
      Routers.debtAdd, arguments: data,);
    await fetchDataOwes();
  }

  void checkMoneyOwe(){
    if(dropValue==listName[0]){
      if(owesTotalModel?.isMe??false){
        moneyRemaining=owesTotalModel?.oweMe;
        moneyPaid=owesTotalModel?.paidMe;
      }else if(owesTotalModel?.isUser??false){
        moneyRemaining=owesTotalModel?.oweUser;
        moneyPaid=owesTotalModel?.paidUser;
      }else{
        moneyRemaining=0;
        moneyPaid=0;
      }
    }else if(dropValue==listName[1]){
      moneyRemaining=owesTotalModel?.oweMe;
      moneyPaid=owesTotalModel?.paidMe;
    }else{
      moneyRemaining=owesTotalModel?.oweUser;
      moneyPaid=owesTotalModel?.paidUser;
    }
    notifyListeners();
  }

  void checkOwes(){
    final myMoney=  (owesTotalModel?.oweMe??0)- (owesTotalModel?.paidMe??0);
    final yourMoney=  (owesTotalModel?.oweUser??0)- (owesTotalModel?.paidUser??0);
    if(owesTotalModel?.isMe??false){
      messageOwes='${DebtLanguage.iOwe} ${
        myCustomerModel?.fullName?.split(' ').last}: ${
          AppCurrencyFormat.formatMoneyD(myMoney)}';
    }else if(owesTotalModel?.isUser??false){
      messageOwes='${myCustomerModel?.fullName?.split(' ').last} ${
        DebtLanguage.yourOwes} ${DebtLanguage.me}: ${
          AppCurrencyFormat.formatMoneyD(yourMoney)}';
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
      builder: (context) {
        return const DialogUserManual(
          title: 'Tạo các khoản ghi nợ và trả nợ như thế nào?',
          widget: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Paragraph(
                  content: '- Nếu A nợ B thì A sẽ được thao tác trả nợ và ghi nợ',
                  style: STYLE_MEDIUM
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Paragraph(
                    content: '  + Ví dụ: A nợ B: 500.000 VNĐ',
                    style: STYLE_MEDIUM
                  ),
                ),
                Paragraph(
                  content: '- Thì B sẽ không được phép thao tác nhập khoản nợ hay trả nợ bởi vì A đang còn nợ B.',
                  style: STYLE_MEDIUM
                ),
                SizedBox(height: 5,),
                Paragraph(
                  content: '- Và ngược lại nếu B nợ A thì A cũng sẽ không thao tác được nhập khoản nợ hay trả nợ.',
                  style: STYLE_MEDIUM
                ),
                SizedBox(height: 10,),
                InformationApp(),
              ],
            ),
          ),
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

  dynamic showSuccessDialog(_) async {
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
    await fetchDataOwes();
  }

  void closeDialog(BuildContext context) {
    timer= Timer(
      const Duration(seconds: 1),
      () => Navigator.pop(context),
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

  Future<void> deleteInvoiceOwes(int id) async {
    LoadingDialog.showLoadingDialog(context);
    final result = await owesInvoiceApi.deleteInvoiceOwes(id);

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
      LoadingDialog.hideLoadingDialog(context);
      showSuccessDialog(context);
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
