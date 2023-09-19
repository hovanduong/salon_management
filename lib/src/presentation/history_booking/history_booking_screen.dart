import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'history_booking.dart';

class HistoryBookingScreen extends StatefulWidget {
  const HistoryBookingScreen({super.key});

  @override
  State<HistoryBookingScreen> createState() => _HistoryBookingScreenState();
}

class _HistoryBookingScreenState extends State<HistoryBookingScreen> {
  HistoryBookingViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: HistoryBookingViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) => buildHistoryScreen(),
    );
  }

  Widget buildHeader() {
    return Container(
      color: AppColors.COLOR_WHITE,
      child: ListTile(
        title: Center(
          child: Paragraph(
            content: HistoryLanguage.appointmentSchedule,
            style: STYLE_LARGE,
          ),
        ),
        leading: const Icon(
          Icons.arrow_back,
          color: AppColors.BLACK_500,
        ),
        trailing: const Icon(null),
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      color: AppColors.COLOR_WHITE,
      child: TabBar(
        tabs: [
          Tab(
            text: HistoryLanguage.upcoming,
          ),
          Tab(
            text: HistoryLanguage.done,
          ),
          Tab(
            text: HistoryLanguage.canceled,
          ),
        ],
        indicatorColor: AppColors.PRIMARY_PINK,
        labelStyle: STYLE_MEDIUM_BOLD,
        unselectedLabelColor: AppColors.BLACK_400,
        labelColor: AppColors.PRIMARY_PINK,
      ),
    );
  }

  void diaLogPhone(String phone) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (buildContext, animation,
            secondaryAnimation) {
          return DiaLogPhoneCustomer(
            phone: phone,
            onTapCall: () => _viewModel!.sendPhone(phone, 'tel'),
          );
        });
  }

  Widget buildFirstTab() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) => NotificationService(
        dateTime: DateTime.now(),
        price: '100.000 VNĐ',
        nameUser: 'Trung Thong',
        phoneNumber: '0931390467',
        onTapPhone: () => diaLogPhone('0931390467'),
        widget: const SelectStatusWidget(),
      ),
    );
  }

  Widget buildSecondTab() {
    return Column(
      children: [
        NotificationService(
          dateTime: DateFormat('dd/MM/yyyy HH:mm').parse('25/8/2023 16:06'),
          price: '100.000 VNĐ',
          widget: setStatusNotification('done', 'checkout'),
        ),
      ],
    );
  }

  Widget buildThirdTab() {
    return Column(
      children: [
        NotificationService(
          dateTime: DateFormat('dd/MM/yyyy HH:mm').parse('25/8/2023 16:06'),
          price: '100.000 VNĐ',
          widget: setStatusNotification('canceled', 'cancel'),
        ),
      ],
    );
  }

  Widget setStatusNotification(String type, String status) {
    switch (type) {
      case 'done':
        return StatusDoneWidget.statusDone(status);
      case 'canceled':
        return StatusCanceledWidget.statusCanceled();
      default:
        return StatusUpComingWidget.statusUpComing(status);
    }
  }

  Widget buildContentTab() {
    return SizedBox(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.all(SpaceBox.sizeMedium),
        child: TabBarView(
          children: [
            buildFirstTab(),
            buildSecondTab(),
            buildThirdTab(),
          ],
        ),
      ),
    );
  }

  Widget buildHistoryScreen() {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                buildHeader(),
                buildAppBar(),
                buildContentTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
