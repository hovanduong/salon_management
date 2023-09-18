// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class NotificationService extends StatelessWidget {
  const NotificationService({
    super.key,
    this.dateTime,
    this.widget,
    this.onTapCard,
    this.price,
    this.nameUser,
    this.phoneNumber,
    this.isSwitch,
    this.onChanged,
    this.onTapPhone,
  });

  final DateTime? dateTime;
  final Widget? widget;
  final String? price;
  final String? nameUser;
  final String? phoneNumber;
  final bool? isSwitch;
  final Function()? onTapCard;
  final Function(bool value)? onChanged;
  final Function()? onTapPhone;

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
    String? date;
    if (dateTime != null) {
      final time = DateFormat('HH:mm').format(dateTime!);
      date = DateFormat('dd/MM/yyyy').format(dateTime!);
      final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      if (date == currentDate) {
        date = '${HistoryLanguage.today}, $time';
      } else {
        date = '$date $time';
      }
    }
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
        InkWell(
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
          content: price ?? '',
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
        return Container(
          padding: EdgeInsets.all(SpaceBox.sizeVerySmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(SpaceBox.sizeVerySmall),
            ),
            border: Border.all(
              color: AppColors.BLACK_300,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: const Icon(Icons.more_horiz),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          child: Row(
            children: [
              const Icon(
                Icons.edit,
                color: AppColors.PRIMARY_GREEN,
              ),
              Paragraph(
                content: HistoryLanguage.editAppointmentSchedule,
                style: STYLE_MEDIUM_BOLD.copyWith(
                  color: AppColors.PRIMARY_GREEN,
                ),
              ),
            ],
          ),
        ),
        MenuItemButton(
          child: Row(
            children: [
              const Icon(
                Icons.delete,
                color: AppColors.PRIMARY_RED,
              ),
              Paragraph(
                content: HistoryLanguage.deleteAppointmentSchedule,
                style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.PRIMARY_RED),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // return ListTile(
  //   minLeadingWidth: SpaceBox.sizeSmall,
  //   leading: SvgPicture.asset(AppImages.icLocation),
  //   title: Paragraph(
  //     content: address ?? '',
  //     style: STYLE_SMALL_BOLD.copyWith(fontSize: SpaceBox.sizeMedium),
  //   ),
  // );

  Widget buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: AppButton(
            content: HistoryLanguage.pay,
            enableButton: true,
          ),
        ),
        SizedBox(
          width: SpaceBox.sizeBig,
        ),
        buildButtonMore(),
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
              buildLine(),
              buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
