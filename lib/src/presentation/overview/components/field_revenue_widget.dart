import 'package:flutter/material.dart';

import '../../../configs/constants/app_space.dart';
import '../../../configs/language/homepage_language.dart';
import '../../../utils/app_currency.dart';
import 'components.dart';

class FieldRevenueWidget extends StatelessWidget {
  const FieldRevenueWidget({super.key,
    this.totalRevenue, 
    this.growthRevenue, 
    this.totalAppointmentConfirm, 
    this.growthAppointmentConfirm, 
    this.totalAppointmentCancel, 
    this.growthAppointmentCancel, 
    this.totalClient, 
    this.growthClient, 
    this.totalBeforeRevenue, 
    this.totalBeforeAppointmentConfirm, 
    this.totalBeforeAppointmentCancel, 
    this.totalBeforeClient,
  });

  final num? totalRevenue;
  final num? totalBeforeRevenue;
  final num? growthRevenue;
  final num? totalAppointmentConfirm;
  final num? totalBeforeAppointmentConfirm;
  final num? growthAppointmentConfirm;
  final num? totalAppointmentCancel;
  final num? totalBeforeAppointmentCancel;
  final num? growthAppointmentCancel;
  final num? totalClient;
  final num? totalBeforeClient;
  final num? growthClient;

  bool isInteger(String input) {
  try {
    int.parse(input);
    return true; 
  } catch (e) {
    return false; 
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CardServiceWidget(
                  title: HomePageLanguage.revenue,
                  total: totalRevenue!=null? AppCurrencyFormat.formatMoneyVND(
                    totalRevenue ?? 0,
                  ):'',
                  money: growthRevenue!=null?
                  '${AppCurrencyFormat.formatMoney(totalBeforeRevenue)} (${
                    isInteger(growthRevenue.toString())? growthRevenue!*100
                    : (growthRevenue!*100).toStringAsFixed(2)}%)'
                  : '',
                ),
              ),
              Expanded(
                child: CardServiceWidget(
                  title: HomePageLanguage.appointmentNumber,
                  total: totalAppointmentConfirm!=null?
                    totalAppointmentConfirm.toString() : '',
                  money:growthAppointmentConfirm!=null
                  ?'$totalBeforeAppointmentConfirm (${growthAppointmentConfirm!*100}%)'
                  : '',
                ),
              ),
            ],
          ),
          Row(children: [
            Expanded(
              child: CardServiceWidget(
                title: HomePageLanguage.appointmentCanceled,
                total: totalAppointmentCancel!=null?
                totalAppointmentCancel.toString() :'',
                money: growthAppointmentCancel!=null
                  ? '$totalBeforeAppointmentCancel (${growthAppointmentCancel!*100}%)'
                  :'',
              ),
            ),
            Expanded(
              child: CardServiceWidget(
                title: HomePageLanguage.newClient,
                total: totalClient!=null? totalClient.toString():'',
                money: growthClient!=null
                  ? '$totalBeforeClient (${growthClient!*100}%)'
                  : '',
              ),
            ),
          ],),
        ],
      ),
    );
  }
}
