// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'model.dart';

class MyBookingModel {
  int? id;
  int? categoryId;
  int? myCustomerId;
  String? address;
  String? date;
  String? note;
  int? userId;
  String? status;
  int? invoiceId;
  num? money;
  num? total;
  MyCustomerModel? myCustomer;
  CategoryModel? category;
  String? createdAt;
  String? deletedAt;
  List<int>? listId;
  String? code;
  bool income;
  bool isBooking;

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
    this.income=false,
    this.isBooking=false,
    this.myCustomerId,
    this.myCustomer,
    this.total,
    this.categoryId,
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
      ..address = json['address']
      ..date = json['date']
      ..status = json['status']
      ..note = json['note']
      ..code=json['code']
      ..income=json['income']
      ..userId = json['userId']
      ..myCustomerId=json['myCustomerId']
      ..isBooking=json['isBooking']
      ..total=json['total']
      ..invoiceId = json['invoiceId']
      ..categoryId=json['categoryId']
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
