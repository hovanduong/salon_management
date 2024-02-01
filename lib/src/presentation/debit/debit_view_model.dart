import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../configs/configs.dart';
import '../../configs/widget/basic/infomation_app.dart';
import '../../configs/widget/dialog/dialog_user_manual.dart';
import '../../resource/model/model.dart';
import '../../resource/service/debit_api.dart';
import '../../resource/service/total_debt_api.dart';
import '../../utils/app_pref.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';
import '../routers.dart';

class DebitViewModel extends BaseViewModel{

  bool isLoading=true;
  bool loadingMore=false;
  bool isShowCase=false;

  GlobalKey keyShowDebtor= GlobalKey();
  GlobalKey keyNote= GlobalKey();
  GlobalKey keyMyDebt= GlobalKey();
  GlobalKey keyMyPaid= GlobalKey();
  GlobalKey keyUDebt= GlobalKey();
  GlobalKey keyUPaid= GlobalKey();

  DebitApi debitApi= DebitApi();
  TotalDebitApi totalDebitApi = TotalDebitApi();

  int page=1;
  int? idUser;

  Timer? timer;

  TextEditingController nameController= TextEditingController();

  TotalDebtModel? totalDebtModel;

  ScrollController scrollController= ScrollController();

  Future<void> init() async{
    idUser = int.parse(await AppPref.getDataUSer('id') ?? '0');
    await fetchData();
    await AppPref.getShowCase('showCaseDebit$idUser').then(
      (value) => isShowCase = value ?? true,
    );
    startShowCase();
    await hideShowcase();
  }

  Future<void> fetchData()async{
    page=1;
    await getTotalDebit();
    notifyListeners();
  }

  Future<void> hideShowcase() async {
    await AppPref.setShowCase('showCaseDebit$idUser', false);
    isShowCase = false;
    notifyListeners();
  }

  void startShowCase() {
    if (isShowCase == true) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        return ShowCaseWidget.of(context).startShowCase(
          [keyShowDebtor, keyNote,keyUPaid,keyUDebt, keyMyPaid, keyMyDebt,],
        );
      });
    }
  }

  Future<void> goToDebtor()async{
    await Navigator.pushNamed(context, Routers.debtor,);
    await fetchData();
  }

  Future<void> pullRefresh() async {
    isLoading = true;
    await init();
    notifyListeners();
  }

  dynamic showDialogNote(_,) {
    showDialog(
      context: context,
      builder: (context) {
        return const DialogUserManual(
          title: 'Sổ nợ là gì?',
          widget: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Paragraph(
                  content: 'Là dùng để tạo các khoản ghi nợ hoặc trả nợ.',
                  style: STYLE_MEDIUM
                ),
                Paragraph(
                  content: 'Bạn nợ người khác, hoặc người khác nợ bạn.',
                  style: STYLE_MEDIUM
                ),
                Paragraph(
                  content: 'Bạn trả nợ cho người khác, hoặc người khác trả nợ cho bạn.',
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

  Future<void> getTotalDebit() async {
    final result = await totalDebitApi.getTotalDebit();

    final value = switch (result) {
      Success(value: final customer) => customer,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      isLoading = true;
    } else if (value is Exception) {
      isLoading = true;
    } else {
      isLoading = false;
      totalDebtModel = value as TotalDebtModel;
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
