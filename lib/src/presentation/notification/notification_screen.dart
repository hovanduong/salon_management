// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/notification_language.dart';
import '../../configs/widget/basic/notification_update.dart';
import '../../resource/service/my_booking.dart';
import '../../utils/check_time.dart';
import '../base/base.dart';
import 'components/message_notification.dart';
import 'notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: NotificationViewModel(),
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
                buildNotificationScreen(),
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
          title: NotificationLanguage.notification,
        ),
      ),
    );
  }

  Widget buildEmptyData() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: SizeToPadding.sizeBig * 7),
        child: EmptyDataWidget(
          title: NotificationLanguage.notification,
          content: NotificationLanguage.emptyNotification,
        ),
      ),
    );
  }

  Widget buildTitleNotification(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeVerySmall),
      child: Row(
        children: [
          SvgPicture.asset(
            AppImages.icBellApp,
            color: _viewModel!.listCurrent[index].isRead ?? false
                ? AppColors.BLACK_400
                : null,
          ),
          SizedBox(
            width: SizeToPadding.sizeVerySmall,
          ),
          Paragraph(
            content: NotificationLanguage.appointmentUpcoming,
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
              color: _viewModel!.listCurrent[index].isRead ?? false
                  ? AppColors.BLACK_400
                  : AppColors.BLACK_500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageNotification(int index) {
    return MessageNotificationWidget(
      codeBooking: _viewModel!.listCurrent[index].bookingCode,
      color: _viewModel!.listCurrent[index].isRead ?? false
          ? AppColors.BLACK_400
          : AppColors.BLACK_500,
      message: _viewModel!.listCurrent[index].message,
    );
  }

  Widget buildFooterNotification(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: AppCheckTime.checkTimeNotification(
            _viewModel!.listCurrent[index].createdAt ?? '',
          ),
          color: _viewModel!.listCurrent[index].isRead ?? false
              ? AppColors.BLACK_400
              : AppColors.PRIMARY_GREEN,
        ),
        Row(
          children: [
            Paragraph(
              content: NotificationLanguage.details,
              fontWeight: FontWeight.w400,
              color: _viewModel!.listCurrent[index].isRead ?? false
                  ? AppColors.BLACK_400
                  : AppColors.PRIMARY_GREEN,
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: _viewModel!.listCurrent[index].isRead ?? false
                  ? AppColors.BLACK_400
                  : AppColors.PRIMARY_GREEN,
              size: 10,
            )
          ],
        ),
      ],
    );
  }

  Widget buildNewNotification(int index) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVeryVerySmall,
        horizontal: SizeToPadding.sizeSmall,
      ),
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        borderRadius: BorderRadius.circular(SpaceBox.sizeSmall),
        boxShadow: [
          BoxShadow(
            color: AppColors.BLACK_300,
            blurRadius: SpaceBox.sizeVerySmall,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleNotification(index),
          const Divider(
            color: AppColors.BLACK_200,
          ),
          buildMessageNotification(index),
          SizedBox(
            height: SizeToPadding.sizeVerySmall,
          ),
          buildFooterNotification(index),
        ],
      ),
    );
  }

  Widget buildCardNotification(int index) {
    final date = _viewModel!.listCurrent[index].createdAt;
    return InkWell(
      onTap: () async {
        await _viewModel!.putReadNotification(
          _viewModel!.listCurrent[index].id ?? 0,
        );
        await _viewModel!.goToBookingDetails(
          context,
          MyBookingParams(
            id: _viewModel!.listCurrent[index].metaData?.appointmentId,
          ),
        );
        await _viewModel!.pullRefresh();
      },
      child: _viewModel!.listCurrent[index].type == 'reminder'
          ? buildNewNotification(index)
          : NotificationUpdate(date: date),
    );
  }

  Widget buildBody() {
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () => _viewModel!.pullRefresh(),
      child: (_viewModel!.listCurrent.isEmpty && !_viewModel!.isLoading)
          ? buildEmptyData()
          : SizedBox(
              height: MediaQuery.sizeOf(context).height - 90,
              child: ListView.builder(
                // physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                controller: _viewModel!.scrollController,
                itemCount: _viewModel!.loadingMore
                    ? _viewModel!.listCurrent.length + 1
                    : _viewModel!.listCurrent.length,
                itemBuilder: (context, index) {
                  if (index < _viewModel!.listCurrent.length) {
                    return buildCardNotification(index);
                  } else {
                    return const CupertinoActivityIndicator();
                  }
                },
              ),
            ),
    );
  }

  Widget buildNotificationScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildHeader(),
          buildBody(),
        ],
      ),
    );
  }
}
