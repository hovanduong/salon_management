import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/booking_details_language.dart';
import '../../utils/app_currency.dart';
import '../../utils/app_utils.dart';
import '../../utils/date_format_utils.dart';
import '../base/base.dart';
import 'booking_detail_view_model.dart';
import 'components/components.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  BookingDetailsViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    return BaseWidget(
      onViewModelReady: (viewModel) =>
          _viewModel = viewModel!..init(id.toString()),
      viewModel: BookingDetailsViewModel(),
      builder: (context, viewModel, child) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: buildBookingDetailsScreen(),
      ),
    );
  }

  Widget buildAddress(int index) {
    return ListTile(
      minLeadingWidth: SpaceBox.sizeSmall,
      leading: SvgPicture.asset(
        AppImages.icLocation,
        color: AppColors.PRIMARY_GREEN,
      ),
      title: Paragraph(
        content: _viewModel!.listMyBooking[index].address,
        style: STYLE_SMALL_BOLD.copyWith(fontSize: SpaceBox.sizeMedium),
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(
      color: AppColors.BLACK_200,
    );
  }

  Widget buildAppBar() {
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeLarge),
      child: CustomerAppBar(
        onTap: () => Navigator.pop(context),
        title: '#LH000034',
      ),
    );
  }

  Widget buildHeader(int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        boxShadow: [
          BoxShadow(
              blurRadius: SpaceBox.sizeMedium, color: AppColors.BLACK_200),
        ],
      ),
      child: Column(
        children: [
          buildAppBar(),
          buildDivider(),
          buildAddress(index),
        ],
      ),
    );
  }

  Widget buildTitle({
    IconData? icon,
    String? content,
    Widget? trailing,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Paragraph(
              content: content ?? '',
              style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing ?? Container(),
      ],
    );
  }

  Widget buildDateAndStatus(int index, String date) {
    return buildTitle(
        content: AppDateUtils.splitHourDate(
          AppDateUtils.formatDateLocal(
            date,
          ),
        ),
        trailing:
            StatusWidget.status(_viewModel!.listMyBooking[index].status!));
  }

  Widget buildNameClient(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
      child: ItemWidget(
        title: '${BookingDetailsLanguage.client}:',
        content: _viewModel!.listMyBooking[index].myCustomer!.fullName,
        fontWeightContent: FontWeight.w500,
      ),
    );
  }

  Widget buildToTalMoney(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
      child: ItemWidget(
        title: BookingDetailsLanguage.total,
        content: AppCurrencyFormat.formatMoneyVND(
            _viewModel!.listMyBooking[index].total ?? 0),
        color: AppColors.PRIMARY_GREEN,
        isSpaceBetween: true,
        fontWeightContent: FontWeight.bold,
      ),
    );
  }

  Widget buildInfoCard(int index) {
    final date = _viewModel!.listMyBooking[index].date ?? '';
    return Container(
      margin: EdgeInsets.symmetric(vertical: SpaceBox.sizeMedium),
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        boxShadow: [
          BoxShadow(
              blurRadius: SpaceBox.sizeMedium, color: AppColors.BLACK_200),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDateAndStatus(index, date),
          buildNameClient(index),
          buildDivider(),
          buildToTalMoney(index),
        ],
      ),
    );
  }

  Widget buildTitleService(int index) {
    final lengthService = _viewModel!.listMyBooking[index].myServices!.length;
    return Paragraph(
      content: '${BookingDetailsLanguage.informationServices} ($lengthService)',
      style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget buildNoteService(int index) {
    final note = _viewModel!.listMyBooking[index].note;
    return note != 'Trống'
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Paragraph(
                  content: BookingDetailsLanguage.note,
                  style:
                      STYLE_LARGE_BOLD.copyWith(color: AppColors.PRIMARY_GREEN),
                ),
                SizedBox(
                  height: SpaceBox.sizeSmall,
                ),
                Paragraph(
                  content: note,
                  style: STYLE_MEDIUM,
                ),
              ],
            ),
          )
        : Container();
  }

  Widget buildListService(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _viewModel!.listMyBooking[index].myServices?.length,
          itemBuilder: (context, indexService) {
            final money = _viewModel!
                .listMyBooking[index].myServices![indexService].money;
            final service =
                _viewModel!.listMyBooking[index].myServices![indexService].name;
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeToPadding.sizeVeryVerySmall),
              child: ItemWidget(
                content: AppCurrencyFormat.formatMoneyVND(money!),
                title: service,
                fontWeightTitle: FontWeight.w500,
                isSpaceBetween: true,
                color: AppColors.PRIMARY_GREEN,
                fontWeightContent: FontWeight.bold,
              ),
            );
          }),
    );
  }

  Widget buildService(int index) {
    return Container(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        boxShadow: [
          BoxShadow(
              blurRadius: SpaceBox.sizeMedium, color: AppColors.BLACK_200),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleService(index),
          buildListService(index),
          buildDivider(),
          buildNoteService(index),
        ],
      ),
    );
  }

  Widget buildItemScreen() {
    return SafeArea(
      top: true,
      left: false,
      bottom: false,
      right: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _viewModel!.listMyBooking.length,
            itemBuilder: (context, index) => Column(
              children: [
                buildHeader(index),
                buildInfoCard(index),
                buildService(index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBookingDetailsScreen() {
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
                )
            ],
          ),
        ),
      ),
    );
  }
}
