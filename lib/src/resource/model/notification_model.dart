// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'package:flutter/material.dart';

import 'model.dart';

class NotificationModel {
  int? id;
  String? title;
  String? message;
  String? type;
  String? status;
  bool? isRead;
  String? userId;
  String? bookingCode;
  String? deletedAt;
  String? updatedAt;
  String? createdAt;
  MetaDataModel? metaData;
  Color? color;
  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.status,
    this.userId,
    this.createdAt,
    this.deletedAt,
    this.updatedAt,
    this.metaData,
    this.color,
    this.bookingCode,
  });
}

abstract class NotificationModelFactory {
  static List<NotificationModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => NotificationModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static NotificationModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final notificationModel = _fromJson(jsonMap);
    return notificationModel;
  }

  static String toJson(NotificationModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    NotificationModel myCustomer,
  ) {
    final data = <String, dynamic>{};
    data['title'] = myCustomer.title;
    data['message'] = myCustomer.message;
    data['status'] = myCustomer.status;
    data['userId'] = myCustomer.userId;
    data['createdAt'] = myCustomer.createdAt;
    data['deletedAt'] = myCustomer.deletedAt;
    return data;
  }

  static NotificationModel _fromJson(Map<String, dynamic> json) {
    final owes = NotificationModel()
      ..id = json['id']
      ..title = json['title']
      ..message = json['message']
      ..type = json['type']
      ..status = json['status']
      ..isRead = json['isRead']
      ..userId = json['userId']
      ..bookingCode = json['bookingCode']
      ..metaData = json['metaData'] !=null ? 
         MetaDataModelFactory.create(jsonEncode(json['metaData'])) 
        : null
      ..updatedAt= json['updatedAt']
      ..createdAt = json['createdAt']
      ..deletedAt = json['deletedAt'];
    return owes;
  }
}
