import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
    with AutomaticKeepAliveClientMixin {
  BookingHistoryViewModel? _viewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: BookingHistoryViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel?..init(),
      builder: (context, viewModel, child) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: buildHistoryScreen(),
      ),
    );
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
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      color: AppColors.COLOR_WHITE,
      child: TabBar(
        onTap: (value) {
          _viewModel!.setStatus(value);
        },
        tabs: [
          Tab(text: HistoryLanguage.upcoming,),
          Tab(text: HistoryLanguage.done,),
          Tab(text: HistoryLanguage.canceled,),
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
        );
      },
    );
  }

  Widget buildFirstTab() {
    return ScreenTap(
      listCurrent: _viewModel!.listCurrentUpcoming,
      isButton: true,
      isLoadMore: _viewModel!.isLoadMore,
      scrollController: _viewModel!.scrollUpComing,
      onTapCard: (id) => _viewModel!.goToBookingDetails(
        context, 
        MyBookingParams(id: id),
      ),
      onTapPhone: diaLogPhone,
      onRefresh: () async {await _viewModel!.pullRefresh();},
      onChangedStatus: (value, id) =>
          _viewModel!.dialogStatus(value: value, context: context, id: id),
      onTapDeleteBooking: (id) => _viewModel!.showWaningDiaglog(id),
      onTapEditBooking: (myBookingModel) => _viewModel!
          .goToAddBooking(context: context, myBookingModel: myBookingModel),
      onPay: (id) => _viewModel!.goToBookingDetails(
        context, MyBookingParams(id: id, isPayment: true),),
    );
  }

  Widget buildSecondTab() {
    return ScreenTap(
      widget: setStatusNotification(done),
      listCurrent: _viewModel!.listCurrentDone,
      isLoadMore: _viewModel!.isLoadMore,
      scrollController: _viewModel!.scrollDone,
      onTapCard: (id) => _viewModel!.goToBookingDetails(
        context, MyBookingParams(id: id),),
      onTapPhone: diaLogPhone,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
    );
  }

  Widget buildThirdTab() {
    return ScreenTap(
      widget: setStatusNotification(canceled),
      listCurrent: _viewModel!.listCurrentCanceled,
      isLoadMore: _viewModel!.isLoadMore,
      scrollController: _viewModel!.scrollCanceled,
      onTapCard: (id) => _viewModel!.goToBookingDetails(
        context, MyBookingParams(id: id),),
      onTapPhone: diaLogPhone,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
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
        child: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height - 200,
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
        ),
      ),
    );
  }

  Widget buildItemScreen() {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: false,
        child: Scaffold(
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: SizeToPadding.sizeLarge * 3),
            child: FloatingActionButton(
              heroTag: 'addBooking',
              backgroundColor: AppColors.PRIMARY_GREEN,
              onPressed: () => _viewModel!.goToAddBooking(context: context),
              child: const Icon(Icons.add),
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
      ),
    );
  }
}
