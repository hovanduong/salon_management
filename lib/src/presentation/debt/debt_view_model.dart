import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/language/debt_language.dart';
import '../../configs/widget/basic/infomation_app.dart';
import '../../configs/widget/dialog/dialog_user_manual.dart';
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
  List<OwesModel> listOwesUser=[];
  List<OwesModel> listOwes=[];

  TabController? tabController;
  ScrollController scrollControllerMe = ScrollController();
  ScrollController scrollControllerUser = ScrollController();

  String? messageOwes;

  int pageMe=1;
  int pageUser=1;
  int tabCurrent=0;

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
    await getOwesTotal();
    pageMe=1;
    pageUser=1;
    await getOwesInvoice(pageMe, 1);
    listOwesMe=listOwes;
    await getOwesInvoice(pageUser, 0);
    listOwesUser=listOwes;
    scrollControllerMe.addListener(
      () => scrollListener(scrollControllerMe),
    );
    scrollControllerUser.addListener(
      () => scrollListener(scrollControllerUser),
    );
    checkOwes();
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    if(tabCurrent==0){
      pageUser += 1;
      await getOwesInvoice(pageUser, tabCurrent);
      listOwesUser=[...listOwesUser, ...listOwes];
    }else{
      pageMe += 1;
      await getOwesInvoice(pageMe, tabCurrent);
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
      DebtLanguage.yourOwes}: ${AppCurrencyFormat.formatMoneyD(myMoney)}';
    }else if(owesTotalModel?.isUser??false){
      messageOwes='${DebtLanguage.amountOfMoney} ${
      myCustomerModel?.fullName?.split(' ').last} ${DebtLanguage.yourOwes}: ${
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
