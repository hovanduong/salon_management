import 'package:flutter/cupertino.dart';

import '../../../configs/configs.dart';

class MessageNotificationWidget extends StatelessWidget {
  const MessageNotificationWidget({
    super.key,
    this.message,
    this.color,
    this.codeBooking,
  });

  final String? message;
  final Color? color;
  final String? codeBooking;

  @override
  Widget build(BuildContext context) {
    final nameUser = message?.split('/')[0];
    final address = message?.split('/')[1];
    final dateTime = message?.split('/')[2];
    // final indexMessage= messageNotification(index);
    if (nameUser == 'null' && address != 'null') {
      return nameUserNull(address ?? '', dateTime ?? '');
    } else if (nameUser == 'null' && address == 'null') {
      return nameAddressNull(dateTime ?? '');
    } else if (nameUser != 'null' && address == 'null') {
      return addressNull(nameUser ?? '', dateTime ?? '');
    } else {
      return noNull(nameUser ?? '', address ?? '', dateTime ?? '');
    }
  }

  Widget nameUserNull(String address, String dateTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: STYLE_MEDIUM.copyWith(
              color: color ?? AppColors.BLACK_500,
            ),
            children: [
              const TextSpan(
                text: 'Bạn có lịch hẹn tại ',
              ),
              TextSpan(
                text: address,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
              ),
              const TextSpan(
                text: ' vào lúc ',
              ),
              TextSpan(
                text: dateTime,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        buildBookingCode(),
      ],
    );
  }

  Widget nameAddressNull(String dateTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: STYLE_MEDIUM.copyWith(
              color: color ?? AppColors.BLACK_500,
            ),
            children: [
              const TextSpan(
                text: 'Bạn có lịch hẹn vào lúc ',
              ),
              TextSpan(
                text: dateTime,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        buildBookingCode(),
      ],
    );
  }

  Widget addressNull(String nameUser, String dateTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: STYLE_MEDIUM.copyWith(
              color: color ?? AppColors.BLACK_500,
            ),
            children: [
              const TextSpan(
                text: 'Bạn có lịch hẹn tại với ',
              ),
              TextSpan(
                text: nameUser,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
              ),
              const TextSpan(
                text: ' vào lúc ',
              ),
              TextSpan(
                text: dateTime,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        buildBookingCode(),
      ],
    );
  }

  Widget noNull(String nameUser, String address, String dateTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: STYLE_MEDIUM.copyWith(
              color: color ?? AppColors.BLACK_500,
            ),
            children: [
              const TextSpan(
                text: 'Bạn có lịch hẹn tại với ',
              ),
              TextSpan(
                text: nameUser,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
              ),
              const TextSpan(
                text: ' tại ',
              ),
              TextSpan(
                text: address,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
              ),
              const TextSpan(
                text: ' vào lúc ',
              ),
              TextSpan(
                text: dateTime,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        buildBookingCode(),
      ],
    );
  }

  Widget buildBookingCode() {
    return RichText(
        text: TextSpan(
            style: STYLE_MEDIUM.copyWith(
              color: color ?? AppColors.BLACK_500,
            ),
            children: [
          const TextSpan(
            text: 'Mã lịch hẹn: ',
          ),
          TextSpan(
            text: codeBooking != null ? '#$codeBooking' : '',
            style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
          ),
        ]));
  }
}
