import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class NotificationService extends StatelessWidget {
  const NotificationService({super.key, 
    this.dateTime, 
    this.widget, 
    this.address, 
    this.onTap, this.service, this.price, this.time,
    this.nameUser, this.phoneNumber
  });

  final DateTime? dateTime; 
  final Widget? widget;
  final String? address;
  final String? service;
  final String? price;
  final String? time;
  final String? nameUser;
  final String? phoneNumber;
  final Function()? onTap;

  Widget buildTitle({IconData? icon, String? content, Widget? trailing}){
    return Padding(
      padding: EdgeInsets.only(bottom: SpaceBox.sizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: SpaceBox.sizeSmall,),
              Paragraph(
                content: content ?? '',
                style: STYLE_MEDIUM_BOLD,
              ),
            ],
          ),
          trailing ?? Container(),
        ],
      ),
    );
  }

  Widget buildHeaderCard() {
    String? date;
    if(dateTime!=null){
      final time=DateFormat('HH:mm').format(dateTime!);
      date = DateFormat('dd/MM/yyyy').format(dateTime!);
      final currentDate= DateFormat('dd/MM/yyyy').format(DateTime.now());
      if(date == currentDate){
        date= 'Hôm nay, $time';
      }else{
        date= '$date $time';
      }
    }
    return Column(
      children: [
        buildTitle(
          content: date,
          icon: Icons.alarm,
          trailing: widget
        ),
         buildTitle(
          content: nameUser,
          icon: Icons.person,
        ),
         buildTitle(
          content: phoneNumber,
          icon: Icons.phone,
        ),
      ],
    );
  }

  Widget buildService(){
    return Padding(
      padding: EdgeInsets.only(
        top: SpaceBox.sizeMedium, bottom: SpaceBox.sizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(
            content: service ?? '',
            style: STYLE_SMALL_BOLD.copyWith(fontSize: SpaceBox.sizeMedium),
          ),
          Paragraph(
            content: time!=null ? '${time}p' : '',
            style: STYLE_SMALL
          ),
        ],
      ),
    );
  }

  Widget buildPrice(){
    return Paragraph(
      content: price ?? '',
      style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.PRIMARY_PINK),
    );
  }

  Widget buildLine() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SpaceBox.sizeMedium),
      width: double.maxFinite,
      height: 1,
      color: AppColors.BLACK_300,
    );
  }

  Widget buildAddress() {
    return ListTile(
      minLeadingWidth: SpaceBox.sizeSmall,
      leading: SvgPicture.asset(AppImages.icLocation),
      title: Paragraph(
        content: address ?? '',
        style: STYLE_SMALL_BOLD.copyWith(fontSize: SpaceBox.sizeMedium),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SpaceBox.sizeMedium))
        ),
        margin: EdgeInsets.symmetric(vertical: SpaceBox.sizeVerySmall),
        elevation: 7,
        shadowColor: AppColors.BLACK_100,
        child: Padding(
          padding: EdgeInsets.all(SpaceBox.sizeMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeaderCard(),
              buildLine(),
              buildService(),
              buildPrice(),
              buildLine(),
              buildAddress(),
            ],
          ),
        ),
      ),
    );
  }
}