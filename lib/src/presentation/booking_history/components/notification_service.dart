// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

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
    this.isButton = false,
    this.isRemind=false,
    this.onTapDeleteBooking,
    this.onTapEditBooking,
    this.onPay,
    this.context,
    this.onRemind, 
    this.keyRemind, 
    this.keyED
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
  final BuildContext? context;
  final bool isRemind;
  final Function(bool isRemind)? onRemind;
  final GlobalKey? keyRemind;
  final GlobalKey? keyED;

  Widget buildTitle({
    IconData? icon,
    String? content,
    Widget? trailing,
    Color? color,
    double? width,
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
              SizedBox(
                width: width ?? MediaQuery.of(context!).size.width - 150,
                child: Paragraph(
                  content: content ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: STYLE_SMALL_BOLD.copyWith(
                    fontSize: 15,
                    color: color ?? AppColors.BLACK_400,
                  ),
                ),
              ),
            ],
          ),
          trailing ?? Container(),
        ],
      ),
    );
  }

  Widget buildRemind(){
    return Showcase(
      description: BookingLanguage.remindBooking,
      key: keyRemind?? GlobalKey(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(
            content: '${BookingLanguage.remind}: ',
            style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
          ),
          // Switch(
          //   activeColor: AppColors.PRIMARY_GREEN,
          //   value: isRemind, 
          //   onChanged:(value)=> onRemind!(value),
          // ),
          CupertinoSwitch(
            value: isRemind,
            onChanged:(value)=> onRemind!(value),
          ),
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
          width: MediaQuery.of(context!).size.width - 250,
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
        if (isButton) buildRemind() else const SizedBox(),
      ],
    );
  }

  Widget buildPrice() {
    return total!=null? Column(
      children: [
        buildLine(),
        Row(
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
        ),
      ],
    ):Container();
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
    return Showcase(
      key: keyED??GlobalKey(),
      description: BookingLanguage.EDBooking,
      child: MenuAnchor(
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
      ),
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
              child:total!=null? AppButton(
                onTap: () {
                  onPay!();
                },
                content: HistoryLanguage.pay,
                enableButton: true,
              ): Container(),
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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: SpaceBox.sizeVerySmall),
        child: Card(
          elevation: 1,
          color: AppColors.COLOR_WHITE,
          shape: RoundedRectangleBorder(
              side:  const BorderSide(color: AppColors.BLACK_200 ,width: 2),
              borderRadius: BorderRadius.all(Radius.circular(SpaceBox.sizeMedium)),
          ),
          shadowColor: AppColors.COLOR_GREY.withOpacity(0.02),
          child: Padding(
            padding: EdgeInsets.all(SpaceBox.sizeMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeaderCard(),
                buildPrice(),
                if (isButton) buildFooter() else Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
