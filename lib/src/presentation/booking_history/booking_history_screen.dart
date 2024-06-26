// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../resource/service/my_booking.dart';
import '../base/base.dart';
import 'booking_history.dart';
import 'components/components.dart';

const done = 'done';
const canceled = 'Canceled';
const upcoming = 'upcoming';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
  with TickerProviderStateMixin {
  BookingHistoryViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: BookingHistoryViewModel(),
        onViewModelReady: (viewModel) => _viewModel = viewModel?..init(
          dataThis: this,
        ),
        builder: (context, viewModel, child) =>
            //   AnnotatedRegion<SystemUiOverlayStyle>(
            // value: const SystemUiOverlayStyle(
            //   statusBarColor: AppColors.PRIMARY_GREEN,
            //   systemNavigationBarColor: Colors.white,
            //   statusBarIconBrightness: Brightness.dark,
            //   systemNavigationBarIconBrightness: Brightness.dark,
            // ),
            // child: buildHistoryScreen(),
            buildHistoryScreen(),);
  }

  Widget buildHistoryScreen() {
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

  Widget buildIcNotification(){
    return Showcase(
      description: BookingLanguage.notification,
      key: _viewModel!.keyNotification,
      child: InkWell(
        onTap: ()=> _viewModel!.goToNotification(context),
        child: Stack(
          children:[
            SizedBox(
              width: 32,
              height: 32,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset(AppImages.icBellApp, 
                  color: AppColors.COLOR_WHITE, height: 25, width: 25,
                ),
              ),
            ),
             Positioned(
              right: 0,
              top: 0,
              child: NumberNotification(id: _viewModel!.idNotification),)
          ]
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      color: AppColors.PRIMARY_GREEN,
      child: Padding(
        padding: EdgeInsets.only(top: Platform.isAndroid ? 30 : 40),
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          minLeadingWidth: 35,
          leading: const SizedBox(),
          title: Center(
            child: Paragraph(
              content: HistoryLanguage.appointmentSchedule,
              style: STYLE_LARGE.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          trailing: buildIcNotification(),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      color: AppColors.COLOR_WHITE,
      child: TabBar(
        controller: _viewModel!.tabController,
        onTap: (value) {
          _viewModel!.setStatus(value);
        },
        tabs: [
          Tab(
            text: _viewModel!.currentTab==0? '${HistoryLanguage.previousAppointment} (${
              _viewModel!.itemTab})' 
              :HistoryLanguage.previousAppointment,
          ),
          Tab(
            text:_viewModel!.currentTab==1? '${HistoryLanguage.today} (${
              _viewModel!.itemTab})': HistoryLanguage.today,
          ),
          Tab(
            text:_viewModel!.currentTab==2? '${HistoryLanguage.upcoming} (${
              _viewModel!.itemTab})': HistoryLanguage.upcoming,
          ),
          Tab(
            text: HistoryLanguage.done,
          ),
          Tab(
            text: HistoryLanguage.canceled,
          ),
        ],
        isScrollable: true,
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
      ),
    );
  }

  void diaLogPhone(String phone) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (
        buildContext,
        animation,
        secondaryAnimation,
      ) {
        return DiaLogPhoneCustomer(
          phone: phone,
          onTapCall: () => _viewModel!.sendPhone(phone, 'tel'),
          onTapText: () => _viewModel!.sendPhone(phone, 'sms'),
          onTapCopy: () => _viewModel!.copyPhone(phone),
        );
      },
    );
  }

  Widget buildTabDaysBefore() {
    return ScreenTap(
      isDayBefore: true,
      contentEmpty: HistoryLanguage.notificationEmptyBefore,
      listCurrent: _viewModel!.listCurrentDaysBefore,
      isLoading: _viewModel!.isLoading,
      isPullRefresh: _viewModel!.isPullRefresh,
      isButton: true,
      isLoadMore: _viewModel!.isLoadMore,
      scrollController: _viewModel!.scrollDaysBefore,
      onTapCard: (id) => _viewModel!.goToBookingDetails(
        context,
        MyBookingParams(id: id),
      ),
      onTapPhone: diaLogPhone,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      onChangedStatus: (value, id) => _viewModel!
          .dialogStatus(value: value, context: context, id: id),
      onTapDeleteBooking: (id) => _viewModel!.showWaningDiaglog(id),
      onTapEditBooking: (myBookingModel) => _viewModel!.goToAddBooking(
          context: context, myBookingModel: myBookingModel,),
      onPay: (id) => _viewModel!.goToBookingDetails(
        context,
        MyBookingParams(id: id, isPayment: true),
      ),
    );
  }

  Widget buildTabToday() {
    return ScreenTap(
      keyRemind: _viewModel!.keyRemind1,
      keyED: _viewModel!.keyED1,
      keyStatus: _viewModel!.keyStatus1,
      onRemind: (value, list, index)
        => _viewModel!.checkAllowNotification(value, list, index),
      contentEmpty: HistoryLanguage.notificationEmptyToday,
      listCurrent: _viewModel!.listCurrentToday,
      isLoading: _viewModel!.isLoading,
      isPullRefresh: _viewModel!.isPullRefresh,
      isButton: true,
      isLoadMore: _viewModel!.isLoadMore,
      scrollController: _viewModel!.scrollToday,
      onTapCard: (id) => _viewModel!.goToBookingDetails(
        context,
        MyBookingParams(id: id),
      ),
      onTapPhone: diaLogPhone,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      onChangedStatus: (value, id) => _viewModel!
          .dialogStatus(value: value, context: context, id: id),
      onTapDeleteBooking: (id) => _viewModel!.showWaningDiaglog(id),
      onTapEditBooking: (myBookingModel) => _viewModel!.goToAddBooking(
          context: context, myBookingModel: myBookingModel,),
      onPay: (id) => _viewModel!.goToBookingDetails(
        context,
        MyBookingParams(id: id, isPayment: true),
      ),
    );
  }

  Widget buildTabUpcoming() {
    return ScreenTap(
      keyED: _viewModel!.keyED2,
      keyStatus: _viewModel!.keyStatus2,
      keyRemind: _viewModel!.keyRemind2,
      onRemind: (value, list, index)
        => _viewModel!.checkAllowNotification(value, list, index),
      contentEmpty: HistoryLanguage.notificationEmptyUpcoming,
      isLoading: _viewModel!.isLoading,
      listCurrent: _viewModel!.listCurrentUpcoming,
      isPullRefresh: _viewModel!.isPullRefresh,
      isButton: true,
      isLoadMore: _viewModel!.isLoadMore,
      scrollController: _viewModel!.scrollUpComing,
      onTapCard: (id) => _viewModel!.goToBookingDetails(
        context,
        MyBookingParams(id: id),
      ),
      onTapPhone: diaLogPhone,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      onChangedStatus: (value, id) =>
          _viewModel!.dialogStatus(value: value, context: context, id: id),
      onTapDeleteBooking: (id) => _viewModel!.showWaningDiaglog(id),
      onTapEditBooking: (myBookingModel) => _viewModel!
          .goToAddBooking(context: context, myBookingModel: myBookingModel),
      onPay: (id) => _viewModel!.goToBookingDetails(
        context,
        MyBookingParams(id: id, isPayment: true),
      ),
    );
  }

  Widget buildTabDone() {
    return ScreenTap(
      isLoading: _viewModel!.isLoading,
      isPullRefresh: _viewModel!.isPullRefresh,
      widget: setStatusNotification(done),
      listCurrent: _viewModel!.listCurrentDone,
      isLoadMore: _viewModel!.isLoadMore,
      scrollController: _viewModel!.scrollDone,
      onTapCard: (id) => _viewModel!.goToBookingDetails(
        context,
        MyBookingParams(id: id),
      ),
      onTapPhone: diaLogPhone,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      titleEmpty: HistoryLanguage.emptyDoneAppointment,
      contentEmpty: HistoryLanguage.notificationDoneAppointment,
    );
  }

  Widget buildTabCanceled() {
    return ScreenTap(
      isLoading: _viewModel!.isLoading,
      isPullRefresh: _viewModel!.isPullRefresh,
      colorStatus: AppColors.PRIMARY_RED,
      status: HistoryLanguage.cancel,
      // widget: setStatusNotification(canceled),
      listCurrent: _viewModel!.listCurrentCanceled,
      isLoadMore: _viewModel!.isLoadMore,
      scrollController: _viewModel!.scrollCanceled,
      onTapCard: (id) => _viewModel!.goToBookingDetails(
        context,
        MyBookingParams(id: id),
      ),
      onChangedStatus: (value, id) =>
          _viewModel!.dialogStatus(value: value, context: context, id: id),
      isCanceled: true,
      onTapPhone: diaLogPhone,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      titleEmpty: HistoryLanguage.emptyCanceledAppointment,
      contentEmpty: HistoryLanguage.notificationCanceledAppointment,
    );
  }

  Widget setStatusNotification(String status) {
    switch (status) {
      case done:
        return StatusUpWidget.statusUpComing(status);
      case canceled:
        return StatusUpWidget.statusUpComing(status);
      default:
        return StatusUpWidget.statusUpComing(status);
    }
  }

  Widget buildContentTab() {
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
          height: MediaQuery.of(context).size.height - 200,
          child: Padding(
            padding: EdgeInsets.all(SpaceBox.sizeMedium),
            child: TabBarView(
              controller: _viewModel!.tabController,
              children: [
                buildTabDaysBefore(),
                buildTabToday(),
                buildTabUpcoming(),
                buildTabDone(),
                buildTabCanceled(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItemScreen() {
    return DefaultTabController(
      initialIndex: 1,
      length: 5,
      child: Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: SizeToPadding.sizeLarge * 3),
          child: Showcase(
            key: _viewModel!.addBooking,
            description: BookingLanguage.addBooking,
            targetBorderRadius: BorderRadius.circular(
              BorderRadiusSize.sizeMedium,),
            child: FloatingActionButton(
              heroTag: 'addBooking',
              backgroundColor: AppColors.PRIMARY_GREEN,
              onPressed: () => _viewModel!.goToAddBooking(context: context),
              child: const Icon(Icons.add, color: AppColors.COLOR_WHITE,),
            ),
          ),
        ),
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
    );
  }
}
