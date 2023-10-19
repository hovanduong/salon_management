// ignore_for_file: use_late_for_private_fields_and_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/bill_payment_language.dart';
import '../../utils/app_currency.dart';
import '../base/base.dart';
import 'bill_payment.dart';
import 'components/components.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  BillPaymentViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final totalMoney = ModalRoute.of(context)?.settings.arguments;
    return BaseWidget(
      viewModel: BillPaymentViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!
        ..init(
          totalMoney as num?,
        ),
      builder: (context, viewModel, child) => buildBillScreen(),
    );
  }

  Widget buildBackground() {
    return Image.asset(AppImages.backgroundHomePage);
  }

  Widget buildAppBar() {
    return Positioned(
      top: SizeToPadding.sizeBig,
      bottom: 0,
      left: 0,
      right: 0,
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        title: Paragraph(
          textAlign: TextAlign.center,
          content: BillPaymentLanguage.billPayment,
          style: STYLE_LARGE.copyWith(
            color: AppColors.COLOR_WHITE,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        buildBackground(),
        buildAppBar(),
      ],
    );
  }

  Widget buildIconSuccess() {
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeBig),
      child: SvgPicture.asset(
        AppImages.icCheck,
        height: 90,
        width: 90,
      ),
    );
  }

  Widget buildTitleSuccess() {
    return Paragraph(
      content: BillPaymentLanguage.paymentSuccess,
      style: STYLE_LARGE.copyWith(
        color: AppColors.PRIMARY_GREEN,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget buildTitleTransaction() {
    return InkWell(
      onTap: () => _viewModel!.showTransaction(),
      child: Padding(
        padding: EdgeInsets.only(
          top: SizeToPadding.sizeMedium,
          bottom: SizeToPadding.sizeVeryVerySmall,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Paragraph(
              content: BillPaymentLanguage.transactionDetails,
              style: STYLE_MEDIUM.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              _viewModel!.isShowTransaction
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContentTransaction() {
    return _viewModel!.isShowTransaction
        ? Column(
            children: [
              ItemTransactionWidget(
                title: BillPaymentLanguage.paymentMethod,
                content: 'Debit Card',
              ),
              ItemTransactionWidget(
                title: BillPaymentLanguage.status,
                content: BillPaymentLanguage.done,
                color: AppColors.PRIMARY_GREEN,
              ),
              ItemTransactionWidget(
                title: BillPaymentLanguage.time,
                content: _viewModel!.time,
              ),
              ItemTransactionWidget(
                title: BillPaymentLanguage.date,
                content: _viewModel!.date,
              ),
              // ItemTransactionWidget(
              //   title: BillPaymentLanguage.transactionId,
              //   content: '20339219392133212',
              //   isIcon: true,
              // ),
            ],
          )
        : Container();
  }

  Widget buildDivider() {
    return const Divider(color: AppColors.BLACK_200, thickness: 1.3);
  }

  Widget buildPrice() {
    return ItemTransactionWidget(
      title: BillPaymentLanguage.price,
      content: AppCurrencyFormat.formatMoneyVND(_viewModel!.totalMoney ?? 0),
    );
  }

  Widget buildFee() {
    return ItemTransactionWidget(
      title: BillPaymentLanguage.fee,
      content: AppCurrencyFormat.formatMoneyVND(0),
    );
  }

  Widget buildTotal() {
    return ItemTransactionWidget(
      title: BillPaymentLanguage.total,
      content: AppCurrencyFormat.formatMoneyVND(_viewModel!.totalMoney ?? 0),
    );
  }

  Widget buildButtonShare() {
    return Positioned(
      bottom: 90,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(SizeToPadding.sizeMedium),
        child: AppOutlineButton(
          content: BillPaymentLanguage.home,
          onTap: () {
            _viewModel!.goToHome();
          },
        ),
      ),
    );
  }

  Widget buildTransactionDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
      child: Column(
        children: [
          buildTitleTransaction(),
          buildContentTransaction(),
          buildDivider(),
          buildPrice(),
          buildFee(),
          buildDivider(),
          buildTotal(),
        ],
      ),
    );
  }

  Widget buildContentBill() {
    return Column(
      children: [
        buildIconSuccess(),
        buildTitleSuccess(),
        buildTransactionDetails(),
      ],
    );
  }

  Widget buildCardBill() {
    return Positioned(
      top: 150,
      bottom: 0,
      left: 0,
      right: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.COLOR_WHITE,
          boxShadow: [
            BoxShadow(
              blurRadius: SpaceBox.sizeMedium,
              color: AppColors.BLACK_400,
            ),
          ],
          borderRadius: BorderRadius.circular(SpaceBox.sizeBig),
        ),
        child: buildContentBill(),
      ),
    );
  }

  Widget buildBillScreen() {
    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            buildHeader(),
            buildCardBill(),
            buildButtonShare(),
          ],
        ),
      ),
    );
  }
}
