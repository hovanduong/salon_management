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
                    child: headerContentTransaction(),
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

Widget headerContentTransaction() {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryBig),
        child: Image.asset(AppImages.pngUpWork),
      ),
      Padding(
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
              // content: HomePageLanguage.inCome,
              content: 'inCome',
              style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.PRIMARY_GREEN),
            ),
          ),
        ),
      ),
      Paragraph(
        content: "\$ 850.00",
        style: STYLE_LARGE_BIG.copyWith(color: AppColors.BLACK_500),
      ),
      buildContentBill(),
      line(),
      SizedBox(
        height: SpaceBox.sizeMedium,
      ),
      bodyContentCost(),
      Padding(
        padding: EdgeInsets.symmetric(vertical: BorderRadiusSize.sizeLarge),
        child: line(),
      ),
      bodySum(),
      outlineButton(),
    ],
  );
}

Widget buildContentBill() {
  return Column(
    children: [
      buildStatusWidget(),
      buildFormWidget(),
    ],
  );
}

Widget buildStatusWidget() {
  return ItemTransactionDetailsWidget(
    title: 'Status',
    content: 'Income',
    colorContent: AppColors.PRIMARY_GREEN,
  );
}

Widget buildFormWidget() {
  return ItemTransactionDetailsWidget(
    title: 'Form',
    content: 'Update Erroe',
    colorContent: AppColors.BLACK_500,
  );
}

Widget line() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeVeryBig),
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

Widget bodyContentCost() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeVeryBig),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeToPadding.sizeVeryVerySmall),
              child: Paragraph(
                content: TransactionDetailsLanguage.earnings,
                style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.COLOR_GREY),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeToPadding.sizeVeryVerySmall),
              child: Paragraph(
                content: TransactionDetailsLanguage.fee,
                style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.COLOR_GREY),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeToPadding.sizeVeryVerySmall),
              child: Paragraph(
                content: "\$ 870.00",
                style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.BLACK_500),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeToPadding.sizeVeryVerySmall),
              child: Paragraph(
                content: "- \$ 20.00",
                style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.BLACK_500),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget bodySum() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeVeryBig),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeToPadding.sizeVeryVerySmall),
              child: Paragraph(
                content: TransactionDetailsLanguage.total,
                style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.COLOR_GREY),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeToPadding.sizeVeryVerySmall),
              child: Paragraph(
                content: "\$ 850.00",
                style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.BLACK_500),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget outlineButton() {
  return Padding(
    padding: EdgeInsets.all(SizeToPadding.sizeVeryBig),
    child: const OutlineButtonWidget(),
  );
}
