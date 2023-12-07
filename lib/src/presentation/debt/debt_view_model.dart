import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/language/debt_language.dart';
import '../../resource/model/model.dart';
import '../../resource/model/owes_model.dart';
import '../../resource/service/owes_invoice_api.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class DebtViewModel extends BaseViewModel{

  bool isLoading=true;
  bool isShowOwes=true;

  OwesInvoiceApi owesInvoiceApi= OwesInvoiceApi();

  GlobalKey add= GlobalKey();

  MyCustomerModel? myCustomerModel;
  OwesTotalModel? owesTotalModel;

  List<OwesModel> listOwes=[];
  List<OwesModel> listCurrent=[];

  TabController? tabController;

  String? messageOwes;

  int page=1;

  Future<void> init(MyCustomerModel? params, {dynamic dataThis}) async{
    tabController=TabController(length: 2, vsync: dataThis);
    myCustomerModel=params;
    await fetchDataOwes();
    // await AppPref.getShowCase('showCaseAppointment').then(
    //   (value) => isShowCase=value??true,);
    // startShowCase();
    // await hideShowcase();
    notifyListeners();
  }

  Future<void> fetchDataOwes()async{
    page=1;
    await getOwesInvoice(page);
    listCurrent=listOwes;
    await getOwesTotal();
    checkOwes();
    notifyListeners();
  }

  void checkOwes(){
    if(owesTotalModel?.isMe??false){
      messageOwes='${DebtLanguage.amountOfMoney} ${DebtLanguage.me} ${
        DebtLanguage.yourOwes}: ${owesTotalModel?.oweMe}';
    }else{
      messageOwes='${DebtLanguage.amountOfMoney} ${
        myCustomerModel?.fullName} ${DebtLanguage.yourOwes}: ${
          owesTotalModel?.oweUser}';
    }
    notifyListeners();
  }

  Future<void> pullRefresh()async{
    isLoading=true;
    await fetchDataOwes();
    notifyListeners();
  }

  Future<void> goToDebtAdd() =>
    Navigator.pushNamed(context, 
      Routers.debtAdd, arguments: myCustomerModel,);

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

  Future<void> getOwesInvoice(int page,) async {
    final result = await owesInvoiceApi.getOwesInvoice(
      OwesInvoiceParams(
        page: page,
        id: myCustomerModel?.id
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
