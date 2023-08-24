import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/homepage_language.dart';
import '../../configs/language/transaction_details.dart';
import '../base/base.dart';
import 'components/item_transaction_details_widget.dart';
import 'components/outlinebutton_widget.dart';
import 'transaction-details_viewmodel.dart';

class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({super.key});

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  TransactionDetailsViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<TransactionDetailsViewModel>(
      viewModel: TransactionDetailsViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) {
        return buildTransactionDetails();
      },
    );
  }

  Widget buildTransactionDetails() {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                ),
                backgroundImage(),
                headerTransaction(),
                Positioned(
                  top: Size.sizeBig,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: AppColors.COLOR_WHITE,
                      borderRadius: BorderRadius.all(
                        Radius.circular(BorderRadiusSize.sizeLarge),
                      ),
                    ),
                    child: Column(
                      children: [
                        buildUpWorkPNGWidget(),
                        buildInComeWidget(),
                        buildPriceWidget(),
                        buildContentBill(),
                        SizedBox(
                          height: SpaceBox.sizeMedium,
                        ),
                        outlineButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget backgroundImage() {
  return Image.asset(AppImages.backgroundHomePage);
}

Widget headerTransaction() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryVeryBig),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          Icons.chevron_left,
          size: Size.sizeMedium,
          color: AppColors.COLOR_WHITE,
        ),
        Paragraph(
          content: TransactionDetailsLanguage.transactionDetails,
          style: STYLE_LARGE.copyWith(
            color: AppColors.COLOR_WHITE,
            fontWeight: FontWeight.w600,
          ),
        ),
        SvgPicture.asset(AppImages.icDots),
      ],
    ),
  );
}

Widget buildUpWorkPNGWidget() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryBig),
    child: Image.asset(AppImages.pngUpWork),
  );
}

Widget buildInComeWidget() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.BLACK_200,
        borderRadius: BorderRadius.all(
          Radius.circular(BorderRadiusSize.sizeLarge),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: SizeToPadding.sizeVeryVerySmall,
            bottom: SizeToPadding.sizeVeryVerySmall,
            left: SizeToPadding.sizeVerySmall,
            right: SizeToPadding.sizeVerySmall),
        child: Paragraph(
          content: TransactionDetailsLanguage.income,
          style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.PRIMARY_GREEN),
        ),
      ),
    ),
  );
}

Widget buildPriceWidget() {
  return Paragraph(
    content: "\$ 850.00",
    style: STYLE_LARGE_BIG.copyWith(color: AppColors.BLACK_500),
  );
}

Widget buildContentBill() {
  return Column(
    children: [
      buildTransactionDetailsWidget(),
      buildStatusWidget(),
      buildFormWidget(),
      buildTimeWidget(),
      buildDateWidget(),
      buildLineWidget(),
      buildEarningsWidget(),
      buildFeeWidget(),
      buildLineWidget(),
      buildTotalWidget(),
    ],
  );
}

Widget buildTransactionDetailsWidget() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: TransactionDetailsLanguage.transactionDetails,
          style: STYLE_MEDIUM_BOLD.copyWith(),
        ),
        SvgPicture.asset(
          AppImages.icChevronDown,
          color: AppColors.BLACK_500,
          width: 25,
          height: 25,
        ),
      ],
    ),
  );
}

Widget buildStatusWidget() {
  return ItemTransactionDetailsWidget(
    title: TransactionDetailsLanguage.status,
    content: TransactionDetailsLanguage.income,
    colorContent: AppColors.FIELD_GREEN,
  );
}

Widget buildFormWidget() {
  return ItemTransactionDetailsWidget(
    title: TransactionDetailsLanguage.from,
    content: 'Upwork Escrow',
  );
}

Widget buildTimeWidget() {
  return ItemTransactionDetailsWidget(
    title: TransactionDetailsLanguage.time,
    content: '10:00 AM',
  );
}

Widget buildDateWidget() {
  return ItemTransactionDetailsWidget(
    title: TransactionDetailsLanguage.date,
    content: 'Feb 30,2022',
  );
}

Widget buildLineWidget() {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: SizeToPadding.sizeVeryBig,
      vertical: SizeToPadding.sizeBig,
    ),
    child: Container(
      width: double.infinity,
      height: 1,
      decoration: BoxDecoration(
        color: AppColors.COLOR_GREY,
        border: Border.all(),
      ),
    ),
  );
}

Widget buildEarningsWidget() {
  return ItemTransactionDetailsWidget(
    title: TransactionDetailsLanguage.earnings,
    content: '\$ 870.00',
  );
}

Widget buildFeeWidget() {
  return ItemTransactionDetailsWidget(
    title: TransactionDetailsLanguage.fee,
    content: '- \$ 20.00',
  );
}

Widget buildTotalWidget() {
  return ItemTransactionDetailsWidget(
    title: TransactionDetailsLanguage.total,
    content: '\$ 850.00',
  );
}

Widget outlineButton() {
  return Padding(
    padding: EdgeInsets.all(SizeToPadding.sizeVeryBig),
    child: const OutlineButtonWidget(),
  );
}
