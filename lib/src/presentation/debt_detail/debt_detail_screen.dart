// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/debt_language.dart';
import '../../resource/model/model.dart';
import '../../utils/app_currency.dart';
import '../../utils/date_format_utils.dart';
import '../base/base.dart';
import 'debt_detail.dart';

class DebtDetailsScreen extends StatefulWidget {
  const DebtDetailsScreen({super.key});

  @override
  State<DebtDetailsScreen> createState() => _DebtDetailsScreenState();
}

class _DebtDetailsScreenState extends State<DebtDetailsScreen> {
  DebtDetailViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final model = ModalRoute.of(context)!.settings.arguments;
    return BaseWidget(
      onViewModelReady: (viewModel) =>
          _viewModel = viewModel!..init(model! as OwesModel),
      viewModel: DebtDetailViewModel(),
      builder: (context, viewModel, child) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.PRIMARY_GREEN,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: buildDebtDetailsScreen(),
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(
      color: AppColors.BLACK_200,
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
          title: DebtLanguage.debtDetails,
        ),
      ),
    );
  }

  Widget buildTitle({
    String? title,
    String? content,
    bool isDivider=false,
    Color? colorContent,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Paragraph(
                content: title ?? '',
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
              ),
              Paragraph(
                content: content ?? '',
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600, 
                  color: colorContent,),
              ),
            ],
          ),
        ),
        if (isDivider) buildDivider() else const SizedBox(),
      ],
    );
  }

  Widget buildCodeDebt() {
    return buildTitle(
      isDivider: true,
      content: _viewModel!.owesModel?.code,
      title: DebtLanguage.debtCode,
    );
  }

  Widget buildMoneyDebt() {
    return buildTitle(
      content: AppCurrencyFormat.formatMoneyD(_viewModel!.owesModel?.money??0),
      title: _viewModel!.owesModel?.isDebit??false
        ? DebtLanguage.amountOwed : DebtLanguage.amountPaid,
      colorContent: _viewModel!.owesModel?.isDebit??false? AppColors.Red_Money
        : AppColors.Green_Money,
      isDivider: true,
    );
  }

  Widget buildDate(){
    final date= AppDateUtils.splitHourDate(
      AppDateUtils.formatDateLocal(_viewModel!.owesModel?.createdAt??''),
    );
    return buildTitle(
      content: date,
      title: DebtLanguage.date,
      isDivider: true,
    );
  }

  Widget buildNote(){
    final note= _viewModel!.owesModel?.note;
    return buildTitle(
      content: note,
      title: DebtLanguage.note,
      isDivider: true,
    );
  }

  Widget buildPeopleCreate(){
    return buildTitle(
      content: _viewModel!.owesModel?.isMe??false? DebtLanguage.me:
        _viewModel!.owesModel?.myCustomerOwes?.fullName?.split(' ').last,
      title: DebtLanguage.creator,
      isDivider: true,
    );
  }

  Widget buildInfoCard( ) {
    return Container(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: const BoxDecoration(
        color: AppColors.COLOR_WHITE,
        boxShadow: [
          BoxShadow(
            color: AppColors.BLACK_200,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCodeDebt(),
          buildPeopleCreate(),
          buildMoneyDebt(),
          buildNote(),
          buildDate(),
        ],
      ),
    );
  }

  Widget buildItemScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        child:  Column(
          children: [
            buildHeader(),
            buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget buildDebtDetailsScreen() {
    return StreamProvider<NetworkStatus>(
      initialData: NetworkStatus.online,
      create: (context) =>
          NetworkStatusService().networkStatusController.stream,
      child: NetworkAwareWidget(
        offlineChild: const ThreeBounceLoading(),
        onlineChild: Container(
          color: AppColors.COLOR_WHITE,
          child: Stack(
            children: [
              buildItemScreen(),
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
    );
  }
}
