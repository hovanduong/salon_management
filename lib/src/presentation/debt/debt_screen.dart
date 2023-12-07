// ignore_for_file: use_late_for_private_fields_and_variables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/debit_language.dart';
import '../../configs/language/debt_language.dart';
import '../../configs/language/homepage_language.dart';
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
          title: DebtLanguage.debt,
          widget: InkWell(
            onTap: ()=> _viewModel!.showDialogNote(context),
            child: const Icon(Icons.not_listed_location_outlined, 
              color: AppColors.COLOR_WHITE,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardDebt(){
    return Container(
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
    );
  }

  Widget buildTabBar(){
    return TabBar(
      controller: _viewModel!.tabController,
      tabs: [
        Tab(text: DebtLanguage.myOwes,),
        Tab(text: '${_viewModel!.myCustomerModel?.fullName} ${
          DebtLanguage.yourOwes}',),
      ],
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      labelPadding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeSmall,
      ),
      indicatorColor: AppColors.PRIMARY_PINK,
      labelStyle: STYLE_MEDIUM_BOLD,
      unselectedLabelColor: AppColors.BLACK_400,
      labelColor: AppColors.PRIMARY_PINK,
    );
  }

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
            style: STYLE_LARGE.copyWith(
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
          title: DebtLanguage.totalRemainingOwes,
          money: AppCurrencyFormat.formatMoneyVND(moneyRemaining??0),
          colorMoney: AppColors.Red_Money,
        ),
        buildOwes(
          title: DebtLanguage.totalOwesPaid,
          money: AppCurrencyFormat.formatMoneyVND(moneyPaid??0),
          colorMoney: AppColors.Green_Money,
        ),
      ],
    );
  }

  Widget buildContentTransaction(int index,){
    return   BuildContentCardOwes(
      date: _viewModel!.listCurrent[index].date,
      money: _viewModel!.listCurrent[index].money,
      title: _viewModel!.listCurrent[index].code,
    );
  }

  Widget buildCardOwes(int index){
    return Container(
      margin: EdgeInsets.only(
        top: SizeToPadding.sizeSmall,
        left: SizeToPadding.sizeSmall,
        right: SizeToPadding.sizeSmall,
      ),
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVeryVerySmall,
        horizontal: SizeToPadding.sizeSmall
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
      child: buildContentTransaction(index),
    );
  }

  Widget buildIconEmpty(){
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: SizeToPadding.sizeBig * 4),
        child: EmptyDataWidget(
          title: DebitLanguage.debit,
          content: DebitLanguage.notificationDebitEmpty,
        ),
      ),
    );
  }

  Widget buildTabMyOwes({bool isOwes=false, num? moneyRemaining, num? moneyPaid}){
    return isOwes? SingleChildScrollView(
      child: Column(
        children: [
          buildTotalOwes(
            moneyPaid: moneyPaid,
            moneyRemaining: moneyRemaining
          ),
          if (_viewModel!.listCurrent.isEmpty && !_viewModel!.isLoading) 
          buildIconEmpty() 
          else RefreshIndicator(
            color: AppColors.PRIMARY_GREEN,
            onRefresh: () async {
              await _viewModel!.pullRefresh();
            },
            child: Column(
              children: List.generate(
                _viewModel!.listCurrent.length , buildCardOwes,),
            ),
          ),
        ],
      ),
    ): buildIconEmpty();
  }

  Widget buildTabBarView(){
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: AppColors.COLOR_GREY.withOpacity(0.05),
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height - 280,
          child: TabBarView(
            controller: _viewModel!.tabController,
            children: [
              buildTabMyOwes(
                isOwes: _viewModel!.owesTotalModel?.isMe??false,
                moneyPaid: _viewModel!.owesTotalModel?.paidMe??0,
                moneyRemaining: _viewModel!.owesTotalModel?.oweMe??0,
              ),
              buildTabMyOwes(
                isOwes: _viewModel!.owesTotalModel?.isUser??false,
                moneyPaid: _viewModel!.owesTotalModel?.paidUser??0,
                moneyRemaining: _viewModel!.owesTotalModel?.oweUser??0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(){
    return Column(
      children: [
        buildCardDebt(),
        buildTabBar(),
        buildTabBarView(),
      ],
    );
  }

  Widget buildDebt(){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton:Padding(
        padding: EdgeInsets.only(bottom: SizeToPadding.sizeLarge * 3),
        child: Showcase(
          key: _viewModel!.add,
          description: HomePageLanguage.addInvoice,
          targetBorderRadius: BorderRadius.all(Radius.circular(
            BorderRadiusSize.sizeLarge,),),
          child: FloatingActionButton(
            heroTag: 'addBooking',
            backgroundColor: AppColors.PRIMARY_GREEN,
            onPressed: () =>_viewModel!.goToDebtAdd(),
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
