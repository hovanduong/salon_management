// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class NotificationService extends StatelessWidget {
  const NotificationService({
    super.key,
    this.date,
    this.widget,
    this.onTapCard,
    this.total,
    this.nameUser,
    this.phoneNumber,
    this.onTapPhone, 
    this.isButton=false, 
    this.onTapDeleteBooking, 
    this.onTapEditBooking, 
    this.onPay,
  });

  final String? date;
  final Widget? widget;
  final String? total;
  final String? nameUser;
  final String? phoneNumber;
  final Function()? onTapCard;
  final Function()? onTapPhone;
  final bool isButton;
  final Function()? onTapDeleteBooking;
  final Function()? onTapEditBooking;
  final Function()? onPay;


  Widget buildTitle({
    IconData? icon,
    String? content,
    Widget? trailing,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: SpaceBox.sizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.BLACK_400,
              ),
              SizedBox(
                width: SpaceBox.sizeSmall,
              ),
              Paragraph(
                content: content ?? '',
                style: STYLE_MEDIUM_BOLD.copyWith(
                  color: color ?? AppColors.BLACK_400,
                ),
              ),
            ],
          ),
          trailing ?? Container(),
        ],
      ),
    );
  }

  Widget buildHeaderCard() {
    return Column(
      children: [
        buildTitle(
          content: date,
          icon: Icons.alarm,
          trailing: widget,
        ),
        buildTitle(
          content: nameUser,
          icon: Icons.person_outline,
          color: AppColors.FIELD_GREEN,
        ),
        GestureDetector(
          onTap: () {
            onTapPhone!();
          },
          child: buildTitle(
            content: phoneNumber,
            icon: Icons.phone_outlined,
            color: AppColors.FIELD_GREEN,
          ),
        ),
      ],
    );
  }

  Widget buildPrice() {
    return Row(
      children: [
        Paragraph(
          content: '${HistoryLanguage.total}: ',
          style: STYLE_MEDIUM_BOLD,
        ),
        Paragraph(
          content: total ?? '',
          style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.PRIMARY_PINK),
        ),
      ],
    );
  }

  Widget buildLine() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SpaceBox.sizeMedium),
      width: double.maxFinite,
      height: 1,
      color: AppColors.BLACK_200,
    );
  }

  Widget buildButtonMore() {
    return MenuAnchor(
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            padding: EdgeInsets.all(SpaceBox.sizeVerySmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(SpaceBox.sizeVerySmall),
              ),
              border: Border.all(
                color: AppColors.BLACK_300,
              ),
            ),
            child: const Icon(Icons.more_horiz),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () => onTapEditBooking!(),
          child: Row(
            children: [
              const Icon(
                Icons.edit,
                color: AppColors.PRIMARY_GREEN,
              ),
              Paragraph(
                content: HistoryLanguage.edit,
                style: STYLE_MEDIUM_BOLD.copyWith(
                  color: AppColors.PRIMARY_GREEN,
                ),
              ),
            ],
          ),
        ),
        MenuItemButton(
          onPressed: () => onTapDeleteBooking!(),
          child: Row(
            children: [
              const Icon(
                Icons.delete,
                color: AppColors.PRIMARY_RED,
              ),
              Paragraph(
                content: HistoryLanguage.delete,
                style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.PRIMARY_RED),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFooter() {
    return Column(
      children: [
        buildLine(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: AppButton(
                onTap: (){
                  onPay!();
                },
                content: HistoryLanguage.pay,
                enableButton: true,
              ),
            ),
            SizedBox(
              width: SpaceBox.sizeBig,
            ),
            buildButtonMore(),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCard,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SpaceBox.sizeMedium)),
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
              buildPrice(),
              if (isButton) buildFooter() else Container(),
            ],
          ),
        ),
      ),
    );
  }
}
