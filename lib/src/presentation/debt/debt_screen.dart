// ignore_for_file: use_late_for_private_fields_and_variables
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/debit_language.dart';
import '../../configs/language/debt_language.dart';
import '../../resource/model/model.dart';
import '../../utils/app_currency.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'debt.dart';

class DebtScreen extends StatefulWidget {
  const DebtScreen({super.key});

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> 
  with SingleTickerProviderStateMixin{

  DebtViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final params= ModalRoute.of(context)?.settings.arguments;
    return BaseWidget(
      viewModel: DebtViewModel(), 
      onViewModelReady: (viewModel) => _viewModel=viewModel!..init(
        params as MyCustomerModel?, dataThis: this,),
      builder: (context, viewModel, child) => buildLoading(),
    );
  }

  Widget buildLoading(){
    return Scaffold(
      body: StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.online,
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        child: NetworkAwareWidget(
          offlineChild: const ThreeBounceLoading(),
          onlineChild: Container(
            color: AppColors.COLOR_WHITE,
            child: Stack(
              children: [
                buildDebt(),
                if (_viewModel!.isLoading)
                  const Positioned(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: ThreeBounceLoading(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      color: AppColors.PRIMARY_GREEN,
      child: Padding(
        padding: EdgeInsets.only(
          top: Platform.isAndroid ? 40 : 60,
          bottom: 10,
          left: SizeToPadding.sizeMedium,
          right: SizeToPadding.sizeMedium,
        ),
        child: CustomerAppBar(
          color: AppColors.COLOR_WHITE,
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.COLOR_WHITE,
          ),
          onTap: () {
            Navigator.pop(context);
          },
          title: DebtLanguage.debtManagement,
          widget: Showcase(
            key: _viewModel!.keyNote,
            description: DebtLanguage.userManual,
            child: InkWell(
              onTap: ()=> _viewModel!.showDialogNote(context),
              child: const Icon(Icons.not_listed_location_outlined, 
                color: AppColors.COLOR_WHITE,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardDebt(){
    return Showcase(
      key: _viewModel!.keyOwes,
      description: DebtLanguage.amountOwed,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: SizeToPadding.sizeMedium,
          horizontal: SizeToPadding.sizeVerySmall,
        ),
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_GREEN,
          borderRadius: BorderRadius.circular(BorderRadiusSize.sizeMedium),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
          child: ListTile(
            leading: SvgPicture.asset(AppImages.accumulatedPoints),
            title: Paragraph(
              content: DebtLanguage.currentDebt,
              style: STYLE_MEDIUM.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.COLOR_WHITE,
              ),
            ),
            subtitle: Paragraph(
              content: _viewModel!.messageOwes,  
              style: STYLE_SMALL_BOLD.copyWith(
                color: AppColors.COLOR_WHITE,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget buildTabBar(){
  //   return TabBar(
  //     controller: _viewModel!.tabController,
  //     onTap: (index)=> _viewModel!.changeTab(index),
  //     tabs: [
  //       Tab(text: DebtLanguage.me,),
  //       Tab(text: _viewModel!.myCustomerModel?.fullName?.split(' ').last,),
  //     ],
  //     indicatorSize: TabBarIndicatorSize.tab,
  //     indicatorPadding: EdgeInsets.zero,
  //     padding: EdgeInsets.zero,
  //     labelPadding: EdgeInsets.symmetric(
  //       horizontal: SizeToPadding.sizeSmall,
  //     ),
  //     indicatorColor: AppColors.PRIMARY_PINK,
  //     labelStyle: STYLE_MEDIUM_BOLD,
  //     unselectedLabelColor: AppColors.BLACK_400,
  //     labelColor: AppColors.PRIMARY_PINK,
  //   );
  // }

  Widget buildOwes({String? title, String? money, Color? colorMoney}){
    return Container(
      width: MediaQuery.sizeOf(context).width/2,
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        border: Border.all(
          color: AppColors.BLACK_200,
          strokeAlign: 2,
        ),
      ),
      child: Column(
        children: [
          Paragraph(
            content: title??'',
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: SpaceBox.sizeSmall,),
          Paragraph(
            content: money??'',
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
              color: colorMoney,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalOwes({num? moneyRemaining, num? moneyPaid}){
    return Row(
      children: [
        buildOwes(
          title: DebtLanguage.totalOwesPaid,
          money: AppCurrencyFormat.formatMoneyD(moneyPaid??0),
          colorMoney: AppColors.Green_Money,
        ),
        buildOwes(
          title: DebtLanguage.totalDebt,
          money: AppCurrencyFormat.formatMoneyD(moneyRemaining??0),
          colorMoney: AppColors.Red_Money,
        ),
      ],
    );
  }

  Widget buildContentTransaction(int index, List<OwesModel> listCurrent,){
    return BuildContentCardOwes(
      colorMoney: listCurrent[index].isDebit??false? 
        AppColors.Red_Money: AppColors.Green_Money,
      date: listCurrent[index].date,
      money: listCurrent[index].money,
      title: listCurrent[index].code,
      nameCreator: listCurrent[index].isMe??false? DebtLanguage.me:
        _viewModel!.myCustomerModel?.fullName?.split(' ').last,
      note: listCurrent[index].note,
    );
  }

  Widget buildCardOwes(int index, List<OwesModel> listCurrent,){
    return InkWell(
      onTap: ()=> _viewModel!.goToDebtDetail(listCurrent[index]),
      child: Container(
        margin: EdgeInsets.only(
          top: SizeToPadding.sizeSmall,
          left: SizeToPadding.sizeSmall,
          right: SizeToPadding.sizeSmall,
        ),
        padding: EdgeInsets.symmetric(
          vertical: SizeToPadding.sizeVeryVerySmall,
          horizontal: SizeToPadding.sizeSmall,
        ),
        decoration: BoxDecoration(
          color: AppColors.COLOR_WHITE,
          borderRadius: BorderRadius.all(
            Radius.circular(BorderRadiusSize.sizeSmall),),
          boxShadow: [
            BoxShadow(color: AppColors.BLACK_200,
              blurRadius: BorderRadiusSize.sizeMedium,
              blurStyle: BlurStyle.solid,
            ),
          ],
        ),
        child: buildContentTransaction(index, listCurrent),
      ),
    );
  }

  Widget buildIconEmpty(){
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: SizeToPadding.sizeBig * 4),
        child: EmptyDataWidget(
          title: DebitLanguage.debit,
          content: DebitLanguage.notificationDebitEmpty,
        ),
      ),
    );
  }

  Widget buildHistoryPaidAndOwes(List<OwesModel> listCurrent, 
    ScrollController scrollController){
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: Container(
        padding: EdgeInsets.only(bottom: SizeToPadding.sizeMedium),
        height: MediaQuery.sizeOf(context).height/1.67,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          controller: scrollController,
          itemCount: _viewModel!.loadingMore
              ? listCurrent.length + 1
              : listCurrent.length,
          itemBuilder: (context, index) {
            if (index < listCurrent.length) {
              return buildCardOwes(index, listCurrent);
            } else {
              return const CupertinoActivityIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget buildTabMyOwes( List<OwesModel> listCurrent, 
    ScrollController scrollController,{bool isOwes=false, 
      num? moneyRemaining, num? moneyPaid,}){
    return Showcase(
      key: _viewModel!.keyHistory,
      description: DebtLanguage.historyOwes,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
          child: Column(
            children: [
              buildTotalOwes(
                moneyPaid: moneyPaid,
                moneyRemaining: moneyRemaining,
              ),
              if (listCurrent.isEmpty && !_viewModel!.isLoading) 
              buildIconEmpty() 
              else buildHistoryPaidAndOwes(listCurrent, scrollController),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildTabBarView(){
  //   return Showcase(
  //     key: _viewModel!.keyHistory,
  //     description: DebtLanguage.historyOwes,
  //     child: RefreshIndicator(
  //       color: AppColors.PRIMARY_GREEN,
  //       onRefresh: () async {
  //         await _viewModel!.pullRefresh();
  //       },
  //       child: SingleChildScrollView(
  //         physics: const AlwaysScrollableScrollPhysics(),
  //         child: Container(
  //           color: AppColors.COLOR_GREY.withOpacity(0.05),
  //           width: double.maxFinite,
  //           height: MediaQuery.of(context).size.height - 270,
  //           child: TabBarView(
  //             controller: _viewModel!.tabController,
  //             children: [
  //               buildTabMyOwes(
  //                 _viewModel!.listOwesMe,
  //                 _viewModel!.scrollControllerMe,
  //                 isOwes: _viewModel!.owesTotalModel?.isMe??false,
  //                 moneyPaid: _viewModel!.owesTotalModel?.paidMe??0,
  //                 moneyRemaining: _viewModel!.owesTotalModel?.oweMe??0,
  //               ),
  //               buildTabMyOwes(
  //                 _viewModel!.listOwesUser,
  //                 _viewModel!.scrollControllerUser,
  //                 isOwes: _viewModel!.owesTotalModel?.isUser??false,
  //                 moneyPaid: _viewModel!.owesTotalModel?.paidUser??0,
  //                 moneyRemaining: _viewModel!.owesTotalModel?.oweUser??0,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildSelectCreator(){
    return SelectCreatorWidget( 
      listName: _viewModel!.listName,
      dropValue: _viewModel!.dropValue,
      onChanged: (value)=> _viewModel!.setData(value),
    );
  }

  Widget buildBody(){
    return Column(
      children: [
        buildCardDebt(),
        buildSelectCreator(),
        buildTabMyOwes(
          _viewModel!.listOwesMe,
          _viewModel!.scrollControllerMe,
          isOwes: _viewModel!.owesTotalModel?.isMe??false,
          moneyPaid: _viewModel!.moneyPaid??0,
          moneyRemaining: _viewModel!.moneyRemaining??0,
        ),
        // buildTabBar(),
        // buildTabBarView(),
      ],
    );
  }

  Widget buildDebt(){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton:Padding(
        padding: EdgeInsets.only(bottom: SizeToPadding.sizeLarge * 3),
        child: Showcase(
          key: _viewModel!.keyAddDebt,
          description: DebtLanguage.addDebt,
          targetBorderRadius: BorderRadius.all(Radius.circular(
            BorderRadiusSize.sizeLarge,),),
          child: FloatingActionButton(
            heroTag: 'addBooking',
            backgroundColor: AppColors.PRIMARY_GREEN,
            onPressed: () async{
              await _viewModel!.goToDebtAdd();
              await _viewModel!.fetchDataOwes();
            },
            child: const Icon(Icons.add, color: AppColors.COLOR_WHITE,),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildBody(),
          ],
        ),
      ),
    );
  }
}
