// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'model.dart';

class MyBookingModel {
  int? id;
  String? address;
  String? date;
  String? note;
  int? userId;
  String? status;
  int? invoiceId;
  num? money;
  MyCustomerModel? myCustomer;
  CategoryModel? category;
  String? createdAt;
  String? deletedAt;
  List<int>? listId;
  String? code;

  MyBookingModel({
    this.id,
    this.money,
    this.userId,
    this.address,
    this.date,
    this.status,
    this.note,
    this.listId,
    this.invoiceId,
    this.category,
    this.deletedAt,
    this.createdAt,
    this.code,
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
      ..address = json['address']
      ..date = json['date']
      ..note = json['note']
      ..userId = json['userId']
      ..status = json['status']
      ..money = json['money']
      ..code=json['code']
      ..invoiceId = json['invoiceId']
      ..myCustomer = json['myCustomer'] != null
          ? MyCustomerModelFactory.create(jsonEncode(json['myCustomer']))
          : null
      ..category = json['category'] != null
          ? CategoryModelFactory.create(jsonEncode(json['category']))
          : null
      ..deletedAt = json['deletedAt']
      ..createdAt = json['createdAt'];
    return myBooking;
  }
}
