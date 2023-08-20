import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../service_add/add_service.dart';


import '../base/base.dart';
import '../routers.dart';


class ServiceListViewModel extends BaseViewModel {
  dynamic init() {}

  String formatMoney(String money) {
    final moneyValue = double.tryParse(
      money.replaceAll('.', '').replaceAll(',', ''),
    );
    if (moneyValue != null) {
      final formatter = NumberFormat('#,###');
      return '${formatter.format(moneyValue)} VNĐ';
    } else {
      return '$money VNĐ';
    }
  }


  void addService() {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const ServiceAddScreen(),
    );
    notifyListeners();
  }


  Future<void> onServiceDetails(BuildContext context) =>
      Navigator.pushNamed(context, Routers.serviceDetails);
}
