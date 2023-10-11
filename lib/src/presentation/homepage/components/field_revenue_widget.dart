import 'package:flutter/material.dart';

import '../../../configs/constants/app_space.dart';
import '../../../configs/language/homepage_language.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
      child: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 130,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ), 
        children: [
          CardServiceWidget(
            title: HomePageLanguage.revenue,
            total: totalRevenue!=null? totalRevenue.toString():'',
            money: growthRevenue!=null?
             '$totalBeforeRevenue (${growthRevenue!*100}%)'
             : '',
          ),
          CardServiceWidget(
            title: HomePageLanguage.appointmentNumber,
            total: totalAppointmentConfirm!=null?
               totalAppointmentConfirm.toString() : '',
            money:growthAppointmentConfirm!=null
             ?'$totalBeforeAppointmentConfirm (${growthAppointmentConfirm!*100}%)'
             : '',
          ),
          CardServiceWidget(
            title: HomePageLanguage.appointmentCanceled,
            total: totalAppointmentCancel!=null?
             totalAppointmentCancel.toString() :'',
            money: growthAppointmentCancel!=null
              ? '$totalBeforeAppointmentCancel (${growthAppointmentCancel!*100}%)'
              :'',
          ),
          CardServiceWidget(
            title: HomePageLanguage.newClient,
            total: totalClient!=null? totalClient.toString():'',
            money: growthClient!=null
              ? '$totalBeforeClient (${growthClient!*100}%)'
              : '',
          ),
        ],
      ),
    );
  }
}
