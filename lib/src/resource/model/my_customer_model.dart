// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'model.dart';

class MyCustomerModel {
  int? id;
  String? phoneNumber;
  String? fullName;
  String? gender;
  String? email;
  int? userId;
  String? deletedAt;
  String? updateAt;
  String? createdAt;
  bool? isMe;
  bool? isUser;
  num? money;
  OwesModel ? owesModel;
  bool isEditDebt;
  MyCustomerModel({
    this.id,
    this.phoneNumber,
    this.fullName,
    this.gender,
    this.email,
    this.userId,
    this.createdAt,
    this.deletedAt,
    this.updateAt,
    this.isMe,
    this.isUser,
    this.money,
    this.owesModel,
    this.isEditDebt=false,
  });
}

abstract class MyCustomerModelFactory {
  static List<MyCustomerModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => MyCustomerModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static MyCustomerModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final myCustomerModel = _fromJson(jsonMap);
    return myCustomerModel;
  }

  static String toJson(MyCustomerModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    MyCustomerModel myCustomer,
  ) {
    final data = <String, dynamic>{};
    data['phoneNumber'] = myCustomer.phoneNumber;
    data['fullName'] = myCustomer.fullName;
    data['gender'] = myCustomer.gender;
    data['email'] = myCustomer.email;
    data['userId'] = myCustomer.userId;
    data['createdAt'] = myCustomer.createdAt;
    data['deletedAt'] = myCustomer.deletedAt;
    data['updateAt'] = myCustomer.updateAt;
    return data;
  }

  static MyCustomerModel _fromJson(Map<String, dynamic> json) {
    final myCustomer = MyCustomerModel()
      ..id = json['id']
      ..phoneNumber = json['phoneNumber']
      ..fullName = json['fullName']
      ..gender = json['gender']
      ..email = json['email']
      ..userId = json['userId']
      ..createdAt = json['createdAt']
      ..deletedAt = json['deletedAt'];
    return myCustomer;
  }
}
