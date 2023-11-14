import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/homepage_language.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomeViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: HomeViewModel(), 
      onViewModelReady: (viewModel) => _viewModel=viewModel!..init(),
      builder: (context, viewModel, child) => buildLoading(),
    );
  }

  Widget buildLoading() {
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
                buildHomePage(),
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
        padding: EdgeInsets.only(top: Platform.isAndroid ? 20 : 40),
        child: ListTile(
          title: Center(
            child: Paragraph(
              content: HomePageLanguage.home,
              style: STYLE_LARGE.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardMoney(){
    return InkWell(
      onTap: () => _viewModel!.goToCalendar(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
        child: CardMoneyWidget(
          iconShowTotalBalance: _viewModel!.isShowBalance,
          onShowTotalBalance: () => _viewModel!.setShowBalance(),
          money: _viewModel!.totalBalance,
          moneyExpenses: _viewModel!.totalExpenses,
          moneyIncome: _viewModel!.totalIncome,
        ),
      ),
    );
  }

  Widget buildTitleTransaction(){
    return GestureDetector(
      onTap: () => _viewModel!.setShowTransaction(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Paragraph(
            content: HomePageLanguage.allTransactions,
            style: STYLE_LARGE.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.PRIMARY_GREEN,
            ),
          ),
          Icon(_viewModel!.isShowTransaction? Icons.arrow_drop_up
            : Icons.arrow_drop_down, 
            color: AppColors.PRIMARY_GREEN,
          ),
        ],
      ),
    );
  }

  Widget buildTitleCardTransaction(int index){
    return ContentTransactionWidget(
      date: _viewModel!.listCurrent[index].date,
      money: _viewModel!.listCurrent[index].total,
      isMoneyIncome: true,
      isTitle: true,
      nameService: _viewModel!.setDayOfWeek(index),
    );
  }

  Widget buildContentTransaction(int index, int indexService){
    final name= _viewModel!.listCurrent[index].invoices
      ?[indexService].myBooking?.category?.name;
    return ContentTransactionWidget(
      money: _viewModel!.listCurrent[index].invoices?[indexService].myBooking?.money,
      nameService: name,
      color: _viewModel!.colors[indexService%_viewModel!.colors.length],
      isMoneyIncome: _viewModel!.listCurrent[index].invoices
        ?[indexService].myBooking?.income ?? false,
    );
  }

  Widget buildCardTransaction(int index){
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium,
        horizontal: SizeToPadding.sizeSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        borderRadius: BorderRadius.all(
          Radius.circular(BorderRadiusSize.sizeMedium),),
        boxShadow: [
          BoxShadow(color: AppColors.BLACK_200,
            blurRadius: BorderRadiusSize.sizeMedium,
            blurStyle: BlurStyle.solid,
          ),
        ],
      ),
      child: Column(
        children: [
          buildTitleCardTransaction(index),
          ...List.generate(
            _viewModel!.listCurrent[index].invoices!.length,
            (indexService) => buildContentTransaction(index, indexService),
          ),
        ],
      ),
    );
  }

  Widget buildTransaction(){
    return _viewModel!.isShowTransaction?
    (_viewModel!.listCurrent.isEmpty && !_viewModel!.isLoading)?
    Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeBig * 7),
      child: EmptyDataWidget(
        title: HomePageLanguage.emptyTransaction,
        content: HomePageLanguage.notificationEmptyTransaction,
      ),
    ): SizedBox(
      height: MediaQuery.sizeOf(context).height/1.85,
      child: ListView.builder(
        padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _viewModel!.scrollController,
          itemCount: _viewModel!.loadingMore
              ? _viewModel!.listCurrent.length + 1
              : _viewModel!.listCurrent.length,
          itemBuilder: (context, index) {
            if (index < _viewModel!.listCurrent.length) {
              return buildCardTransaction(index);
            } else {
              return const CupertinoActivityIndicator();
            }
          },
      ),
    ) : Container();
  }

  Widget buildBody(){
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () => _viewModel!.pullRefresh(),
      child: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height-150,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildCardMoney(),
              buildTitleTransaction(),
              buildTransaction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHomePage() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: SizeToPadding.sizeLarge * 3),
        child: FloatingActionButton(
          heroTag: 'addBooking',
          backgroundColor: AppColors.PRIMARY_GREEN,
          onPressed: () => _viewModel!.goToAddInvoice(context),
          child: const Icon(Icons.add),
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
