import 'package:flutter/cupertino.dart';

import '../../../configs/configs.dart';

class MessageNotificationWidget extends StatelessWidget {
  const MessageNotificationWidget({
    super.key, this.message, this.color,
  });

  final String? message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final nameUser= message?.split('/')[0];
    final address= message?.split('/')[1];
    final dateTime= message?.split('/')[2];
    // final indexMessage= messageNotification(index);
    if(nameUser =='null' && address !='null' ){
      return nameUserNull(address??'', dateTime??'');
    }else if(nameUser=='null' && address =='null'){
      return nameAddressNull(dateTime??'');
    }else if(nameUser!='null' && address=='null'){
      return addressNull(nameUser??'', dateTime??'');
    }else{
      return noNull(nameUser??'', address??'', dateTime??'');
    }
  }

  Widget nameUserNull(String address, String dateTime){
    return RichText(
      text: TextSpan(
        style: STYLE_MEDIUM.copyWith(
          color: color??AppColors.BLACK_500,
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
    );
  }

  Widget nameAddressNull(String dateTime){
    return RichText(
      text: TextSpan(
        style: STYLE_MEDIUM.copyWith(
          color: color??AppColors.BLACK_500,
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
    );
  }

  Widget addressNull(String nameUser, String dateTime){
    return RichText(
      text: TextSpan(
        style: STYLE_MEDIUM.copyWith(
          color: color??AppColors.BLACK_500,
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
    );
  }

  Widget noNull(String nameUser, String address, String dateTime){
    return RichText(
      text: TextSpan(
        style: STYLE_MEDIUM.copyWith(
          color: color??AppColors.BLACK_500,
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
    );
  }
}
