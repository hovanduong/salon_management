// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/debit_language.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'debit_view_model.dart';

class DebitScreen extends StatefulWidget {
  const DebitScreen({super.key});

  @override
  State<DebitScreen> createState() => _DebitScreenState();
}

class _DebitScreenState extends State<DebitScreen> {
  DebitViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: DebitViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
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
                buildDebit(),
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
          minLeadingWidth: 35,
          leading: const SizedBox(),
          title: Center(
            child: Paragraph(
              content: DebitLanguage.debitBook,
              style: STYLE_LARGE.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          trailing: Showcase(
            key: _viewModel!.keyNote,
            description: DebitLanguage.userManual,
            child: InkWell(
              onTap: () => _viewModel!.showDialogNote(context),
              child: const Icon(
                Icons.not_listed_location_outlined,
                color: AppColors.COLOR_WHITE,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTotalMyDebit() {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeSmall),
      child: FieldRevenueWidget(
        totalOwe: DebitLanguage.totalIOwe,
        totalPaid: DebitLanguage.totalIPaid,
        descriptionOwe: DebitLanguage.showCaseMyDebt,
        keyOwe: _viewModel!.keyMyDebt,
        descriptionPaid: DebitLanguage.showCaseMyPaid,
        keyPaid: _viewModel!.keyMyPaid,
        title: DebitLanguage.myDebitEveryone,
        money: (_viewModel!.totalDebtModel?.totalDebtMe ?? 0) -
            (_viewModel!.totalDebtModel?.totalPaidMe ?? 0),
        colorTitle: AppColors.Red_Money,
        totalLeft: _viewModel!.totalDebtModel?.totalPaidMe ?? 0,
        totalRight: _viewModel!.totalDebtModel?.totalDebtMe ?? 0,
      ),
    );
  }

  Widget buildTotalEveryoneDebit() {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeSmall),
      child: FieldRevenueWidget(
        totalOwe: DebitLanguage.totalEveryoneOwe,
        totalPaid: DebitLanguage.totalEveryonePaid,
        descriptionOwe: DebitLanguage.showCaseUDebt,
        keyOwe: _viewModel!.keyUDebt,
        descriptionPaid: DebitLanguage.showCaseUPaid,
        keyPaid: _viewModel!.keyUPaid,
        title: DebitLanguage.everyoneDebitMe,
        money: (_viewModel!.totalDebtModel?.totalDebtUser ?? 0) -
            (_viewModel!.totalDebtModel?.totalPaidUser ?? 0),
        colorTitle: AppColors.Red_Money,
        totalLeft: _viewModel!.totalDebtModel?.totalPaidUser ?? 0,
        totalRight: _viewModel!.totalDebtModel?.totalDebtUser ?? 0,
      ),
    );
  }

  Widget buildBody() {
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            buildTotalEveryoneDebit(),
            buildTotalMyDebit(),
          ],
        ),
      ),
    );
  }

  Widget buildDebit() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: SizeToPadding.sizeLarge * 3),
        child: Showcase(
          key: _viewModel!.keyShowDebtor,
          description: DebitLanguage.showDebtor,
          targetBorderRadius: BorderRadius.all(
            Radius.circular(
              BorderRadiusSize.sizeLarge,
            ),
          ),
          child: FloatingActionButton(
            heroTag: 'addBooking',
            backgroundColor: AppColors.PRIMARY_GREEN,
            onPressed: () => _viewModel!.goToDebtor(),
            child: const Icon(
              Icons.arrow_forward,
              color: AppColors.COLOR_WHITE,
            ),
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
