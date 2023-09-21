import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../utils/date_format_utils.dart';
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
      onViewModelReady: (viewModel) => _viewModel = viewModel?..init(),
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
    // return LoadMoreWidget(
    //   model: (p0) {
    //     _viewModel!.myBookingModel =p0;
    //     print(p0);
    //     setState(() { });
    //   },
    //   page: 1,
    //   onChanged: () async{
    //     // await _viewModel!.getMyBooking();
    //   },
    //   onChangedPage: (page) async{
    //     await _viewModel!.getMyBooking(page);
    //   },
    //   list: _viewModel!.listCurrent,
    //   widget: NotificationService(
    //     dateTime: AppDateUtils.splitHourDate(
    //       AppDateUtils.formatDateLocal(_viewModel!.listCurrent[0].createdAt!)
    //     ),
    //     price: _viewModel!.myBookingModel.address,
    //     nameUser: 'Trung Thong',
    //     phoneNumber: '0931390467',
    //     onTapPhone: () => diaLogPhone('0931390467'),
    //     widget: const SelectStatusWidget(),
    //   ),
    // );
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 200),
        child: ListView.builder(
          shrinkWrap: true,
          controller: _viewModel!.scrollController,
          itemCount: _viewModel!.isLoadMore
              ? _viewModel!.listCurrent.length + 1
              : _viewModel!.listCurrent.length,
          itemBuilder: (context, index) {
            if (index < _viewModel!.listCurrent.length) {
              final phone =
                  _viewModel!.listCurrent[index].myCustomer?.phoneNumber;
              final date = _viewModel!.listCurrent[index].createdAt;
              return NotificationService(
                onTapCard: () => _viewModel!.goToBookingDetails(
                  context, _viewModel!.listCurrent[index].id!
                ),
                isButton: true,
                dateTime: date != null
                    ? AppDateUtils.splitHourDate(
                        AppDateUtils.formatDateLocal(
                          date,
                        ),
                      )
                    : '',
                total: _viewModel!.listCurrent[index].total.toString(),
                nameUser: _viewModel!.listCurrent[index].myCustomer?.fullName,
                phoneNumber: phone,
                onTapPhone: () => diaLogPhone(phone!),
                widget: SelectStatusWidget(
                  status: _viewModel!.listCurrent[index].status,
                ),
              );
            } else {
              return const CupertinoActivityIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget buildSecondTab() {
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 200),
        child: ListView.builder(
          itemCount: _viewModel!.listCurrent.length,
          itemBuilder: (context, index) {
            final phone =
                _viewModel!.listCurrent[index].myCustomer?.phoneNumber;
            final date = _viewModel!.listCurrent[index].createdAt;
            return NotificationService(
              dateTime: date != null
                  ? AppDateUtils.splitHourDate(
                      AppDateUtils.formatDateLocal(
                        date,
                      ),
                    )
                  : '',
              total: _viewModel!.listCurrent[index].total.toString(),
              nameUser: _viewModel!.listCurrent[index].myCustomer?.fullName,
              phoneNumber: phone,
              onTapPhone: () => diaLogPhone(phone!),
              widget: setStatusNotification('done', 'checkout'),
            );
          },
        ),
      ),
    );
  }

  Widget buildThirdTab() {
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 200),
        child: ListView.builder(
          itemCount: _viewModel!.listCurrent.length,
          itemBuilder: (context, index) {
            final phone =
                _viewModel!.listCurrent[index].myCustomer?.phoneNumber;
            final date = _viewModel!.listCurrent[index].createdAt;
            return NotificationService(
              dateTime: date != null
                  ? AppDateUtils.splitHourDate(
                      AppDateUtils.formatDateLocal(
                        date,
                      ),
                    )
                  : '',
              total: _viewModel!.listCurrent[index].total.toString(),
              nameUser: _viewModel!.listCurrent[index].myCustomer?.fullName,
              phoneNumber: phone,
              onTapPhone: () => diaLogPhone(phone!),
              widget: setStatusNotification('canceled', 'cancel'),
            );
          },
        ),
      ),
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
