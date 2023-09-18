// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'model.dart';

class MyServiceModel {
  int? id;
  String? name;
  int? userId;
  num? money;
  List<CategoryModel>? categories;
  
  String? deletedAt;
  String? createdAt;
  String? updateAt;

  MyServiceModel({
    this.id,
    this.name,
    this.money,
    this.userId,
  
    this.categories,
    this.createdAt,
    this.updateAt,
    this.deletedAt,
  });
}

abstract class MyServiceFactory {
  static List<MyServiceModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => MyServiceFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static MyServiceModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final myService = _fromJson(jsonMap);
    return myService;
  }

  static String toJson(MyServiceModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    MyServiceModel myService,
  ) {
    final data = <String, dynamic>{};
    data['name'] = myService.name;
    data['userId'] = myService.userId;
    data['deletedAt'] = myService.deletedAt;
    data['createdAt'] = myService.createdAt;
    data['money'] = myService.money;
    data['updateAt'] = myService.updateAt;
    return data;
  }

  static MyServiceModel _fromJson(Map<String, dynamic> json) {
    final myService = MyServiceModel()
      ..id = json['id']
      ..name = json['name']
      ..userId = json['userId']
      ..money = json['money']
      ..categories = json['categories'] != null
          ? CategoryModelFactory.createList(jsonEncode(json['categories']))
          : null
      ..deletedAt = json['deletedAt']
      ..createdAt = json['createdAt']
      ..updateAt = json['updateAt'];
    return myService;
  }
}
