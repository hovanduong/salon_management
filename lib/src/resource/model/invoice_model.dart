// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

import 'my_booking_model.dart';

class InvoiceModel {
  int? id;
  String? name;
  int? userId;
  String? code;
  String? status;
  num? discount;
  String? paymentStatus;
  num? total;
  String? myBookingId;
  String? deletedAt;
  String? createdAt;
  MyBookingModel? myBooking;

  InvoiceModel({
    this.id,
    this.name,
    this.userId,
    this.deletedAt,
    this.createdAt,
    this.myBooking,
    this.discount,
    this.status,
    this.code,
    this.myBookingId,
    this.paymentStatus,
    this.total,
  });
}

abstract class InvoiceModelFactory {
  static List<InvoiceModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => InvoiceModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static InvoiceModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final invoiceModel = _fromJson(jsonMap);
    return invoiceModel;
  }

  static String toJson(InvoiceModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    InvoiceModel invoiceModel,
  ) {
    final data = <String, dynamic>{};
    data['name'] = invoiceModel.name;
    data['userId'] = invoiceModel.userId;
    data['deletedAt'] = invoiceModel.deletedAt;
    data['createdAt'] = invoiceModel.createdAt;

    return data;
  }

  static InvoiceModel _fromJson(Map<String, dynamic> json) {
    final invoice = InvoiceModel()
      ..id = json['id']
      ..name = json['name']
      ..userId = json['userId']
      ..code = json['code']
      ..userId = json['userId']
      ..discount = json['discount']
      ..status = json['status']
      ..paymentStatus = json['paymentStatus']
      ..total = json['total']
      ..myBookingId = json['myBookingId']
      ..myBooking = json['myBooking'] != null
          ? MyBookingModelFactory.create(jsonEncode(json['myBooking']))
          : null
      ..deletedAt = json['deletedAt']
      ..createdAt = json['createdAt'];
    return invoice;
  }
}
