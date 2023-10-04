import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
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
    this.onTapCard,
    this.onChangedStatus,
    this.onTapDeleteBooking,
    this.onTapEditBooking, 
    this.onPay,
  });

  final Function()? onRefresh;
  final List<MyBookingModel>? listCurrent;
  final Function(String phone)? onTapPhone;
  final Widget? widget;
  final ScrollController? scrollController;
  final bool isLoadMore;
  final bool isButton;
  final Function(int id)? onTapCard;
  final Function(String value, int id)? onChangedStatus;
  final Function(int id)? onTapDeleteBooking;
  final Function(MyBookingModel myBookingModel)? onTapEditBooking;
  final Function(int id)? onPay;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await onRefresh!();
      },
      child: ListView.builder(
        shrinkWrap: true,
        controller: scrollController,
        itemCount: isLoadMore ? listCurrent!.length + 1 : listCurrent!.length,
        itemBuilder: (context, index) {
          if (index < listCurrent!.length) {
            final phone = listCurrent![index].myCustomer?.phoneNumber;
            final date = listCurrent![index].date;
            final id = listCurrent![index].id;
            return NotificationService(
              onPay: () => onPay!(id!),
              onTapEditBooking: () => onTapEditBooking!(listCurrent![index]),
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
                listCurrent![index].total ?? 0,
              ),
              nameUser: listCurrent![index].myCustomer?.fullName,
              phoneNumber: phone,
              onTapPhone: () => onTapPhone!(phone!),
              widget: widget ??
                  SelectStatusWidget(
                    status: listCurrent![index].status,
                    onChanged: (value) {
                      if (!value.contains(listCurrent![index].status!)) {
                        onChangedStatus!(value, id!);
                      }
                    },
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
