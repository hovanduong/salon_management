import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../base/base.dart';

import '../routers.dart';

class ServiceDetailsViewModel extends BaseViewModel {
  dynamic init() {}

  Future<void> deleteService(String id) async {
    try {
      final CollectionReference serviceCollection =
          FirebaseFirestore.instance.collection('services');

      await serviceCollection.doc(id).delete();
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting service: $e');
    }
  }

  String formatMoney(String money) {
    final moneyValue = double.tryParse(
      money.replaceAll(',', ''),
    );
    if (moneyValue != null) {
      final formatter = NumberFormat('#,###');
      return '${formatter.format(moneyValue)} VNĐ';
    } else {
      return '$money VNĐ';
    }
  }

  // Future<void> onEditService(BuildContext context, ServiceModel? service) =>
  //     Navigator.pushNamed(context, Routers.editService);
  Future<void> onEditService(BuildContext context) => 
      Navigator.pushNamed(context, Routers.editService);
}
