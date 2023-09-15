// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'model.dart';

class MyBookingModel {
  int? id;
  String? money;
  int? userId;
  String? address;
  String? date;
  String? status;
  String? note;
  int? invoiceId;
  List<MyServiceModel>? myServices;
  MyCustomerModel? myCustomer;
  String? deletedAt;
  String? createdAt;

  MyBookingModel({
    this.id,
    this.money,
    this.userId,
    this.address,
    this.date,
    this.status,
    this.note,
    this.invoiceId,
    this.myServices,
    this.deletedAt,
    this.createdAt,
  });
}

abstract class MyBookingModelFactory {
  static List<MyBookingModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => MyBookingModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static MyBookingModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final myBookingModel = _fromJson(jsonMap);
    return myBookingModel;
  }

  static String toJson(MyBookingModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    MyBookingModel myBookingModel,
  ) {
    final data = <String, dynamic>{};
    data['money'] = myBookingModel.money;
    data['userId'] = myBookingModel.userId;
    data['deletedAt'] = myBookingModel.deletedAt;
    data['createdAt'] = myBookingModel.createdAt;
    //  data['myService'] = MyBookingModel.myService != null
    //     ? jsonDecode(MyServiceFactory.toJson(MyBookingModel.myService!))
    //     : null;
    return data;
  }

  static MyBookingModel _fromJson(Map<String, dynamic> json) {
    final myBooking = MyBookingModel()
      ..id = json['id']
      ..money = json['money']
      ..userId = json['userId']
      ..address = json['address']
      ..date = json['date']
      ..status = json['status']
      ..note = json['note']
      ..myCustomer = json['myCustomer'] != null
          ? MyCustomerModelFactory.create(jsonEncode(json['myService']))
          : null
      ..myServices = json['myService'] != null
          ? MyServiceFactory.createList(jsonEncode(json['myService']))
          : null
      ..deletedAt = json['deletedAt']
      ..createdAt = json['createdAt'];
    return myBooking;
  }
}
