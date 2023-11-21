import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../resource/model/my_booking_model.dart';
import '../../../utils/app_currency.dart';
import '../../../utils/date_format_utils.dart';
import 'components.dart';

class ScreenTap extends StatelessWidget {
  const ScreenTap({
    super.key,
    this.onRefresh,
    this.listCurrent,
    this.onTapPhone,
    this.widget,
    this.scrollController,
    this.isLoadMore = false,
    this.isButton = false,
    this.isLoading = false,
    this.isPullRefresh = false,
    this.isCanceled=false,
    this.onTapCard,
    this.onChangedStatus,
    this.onTapDeleteBooking,
    this.onTapEditBooking,
    this.onPay,
    this.titleEmpty,
    this.contentEmpty, 
    this.colorStatus, 
    this.status,
  });

  final Function()? onRefresh;
  final List<MyBookingModel>? listCurrent;
  final Function(String phone)? onTapPhone;
  final Widget? widget;
  final ScrollController? scrollController;
  final bool isLoadMore;
  final bool isButton;
  final bool isLoading;
  final bool isPullRefresh;
  final bool isCanceled;
  final Function(int id)? onTapCard;
  final Function(String value, int id)? onChangedStatus;
  final Function(int id)? onTapDeleteBooking;
  final Function(MyBookingModel myBookingModel)? onTapEditBooking;
  final Function(int id)? onPay;
  final String? titleEmpty;
  final String? contentEmpty;
  final Color? colorStatus;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await onRefresh!();
      },
      child: listCurrent!.isEmpty && !isLoading && !isPullRefresh
          ? Padding(
              padding: EdgeInsets.only(top: SizeToPadding.sizeBig * 7),
              child: EmptyDataWidget(
                title: titleEmpty ?? HistoryLanguage.emptyAppointment,
                content: contentEmpty ??
                    HistoryLanguage.notificationEmptyAppointment,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              controller: scrollController,
              itemCount:
                  isLoadMore ? listCurrent!.length + 1 : listCurrent!.length,
              itemBuilder: (context, index) {
                if (index < listCurrent!.length) {
                  final phone = listCurrent![index].myCustomer?.phoneNumber;
                  final date = listCurrent![index].date;
                  final id = listCurrent![index].id;
                  return NotificationService(
                    context: context,
                    onPay: () => onPay!(id!),
                    onTapEditBooking: () =>
                        onTapEditBooking!(listCurrent![index]),
                    onTapDeleteBooking: () => onTapDeleteBooking!(id!),
                    onTapCard: () => onTapCard!(id!),
                    isButton: isButton,
                    date: date != null
                        ? AppDateUtils.splitHourDate(
                            AppDateUtils.formatDateLocal(
                              date,
                            ),
                          )
                        : '',
                    total: AppCurrencyFormat.formatMoneyVND(
                      listCurrent?[index].money ?? 0,
                    ),
                    nameUser: listCurrent![index].myCustomer?.fullName,
                    phoneNumber: phone,
                    onTapPhone: () => onTapPhone!(phone!),
                    widget: widget ??
                        SelectStatusWidget(
                          status: status ?? HistoryLanguage.confirmed,
                          onChanged: (value) {
                            if(isCanceled && value.contains(HistoryLanguage.confirmed)){
                              onChangedStatus!('Confirmed', id!);
                            }
                            if(!isCanceled && value.contains(HistoryLanguage.cancel)){
                              onChangedStatus!('Canceled', id!);
                            } 
                          },
                          color: colorStatus,
                        ),
                  );
                } else {
                  return const CupertinoActivityIndicator();
                }
              },
            ),
    );
  }
}
