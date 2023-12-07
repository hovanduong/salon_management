// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'model.dart';

class OwesModel {
  int? id;
  String? code;
  String? status;
  String? paymentStatus;
  num? money;
  bool? isMe;
  bool? isUser;
  bool? isDebit;
  String? note;
  num? myCustomerOwesId;
  int? userId;
  String? date;
  String? deletedAt;
  String? updateAt;
  String? createdAt;
  MyCustomerModel? myCustomerOwes;
  OwesModel({
    this.id,
    this.code,
    this.status,
    this.paymentStatus,
    this.money,
    this.isMe,
    this.isUser,
    this.isDebit,
    this.note,
    this.myCustomerOwesId,
    this.userId,
    this.date,
    this.createdAt,
    this.deletedAt,
    this.updateAt,
    this.myCustomerOwes,
  });
}

abstract class OwesModelFactory {
  static List<OwesModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => OwesModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static OwesModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final owesModel = _fromJson(jsonMap);
    return owesModel;
  }

  static String toJson(OwesModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    OwesModel myCustomer,
  ) {
    final data = <String, dynamic>{};
    data['code'] = myCustomer.code;
    data['status'] = myCustomer.status;
    data['paymentStatus'] = myCustomer.paymentStatus;
    data['note'] = myCustomer.note;
    data['userId'] = myCustomer.userId;
    data['createdAt'] = myCustomer.createdAt;
    data['deletedAt'] = myCustomer.deletedAt;
    data['updateAt'] = myCustomer.updateAt;
    return data;
  }

  static OwesModel _fromJson(Map<String, dynamic> json) {
    final owes = OwesModel()
      ..id = json['id']
      ..code = json['code']
      ..status = json['status']
      ..paymentStatus = json['paymentStatus']
      ..money = json['money']
      ..isMe = json['isMe']
      ..isUser = json['isUser']
      ..isDebit = json['isDebit']
      ..note = json['note']
      ..myCustomerOwesId = json['myCustomerOwesId']
      ..userId = json['userId']
      ..date = json['date']
      ..myCustomerOwes = json['myCustomerOwes'] !=null ? 
         MyCustomerModelFactory.create(jsonEncode(json['myCustomerOwes'])) 
        : null
      ..createdAt = json['createdAt']
      ..deletedAt = json['deletedAt'];
    return owes;
  }
}
