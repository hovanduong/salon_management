// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class MyServicceModel {
  int? id;
  String? name;
  int? userId;
  String? deletedAt;
  String? createdAt;
  String? money;
  String? updateAt;

  MyServicceModel({
    this.id,
    this.name,
    this.money,
    this.userId,
    this.createdAt,
    this.updateAt,
    this.deletedAt,
  });
}

abstract class MyServiceFactory {
  static List<MyServicceModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => MyServiceFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static MyServicceModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final myService = _fromJson(jsonMap);
    return myService;
  }

  static String toJson(MyServicceModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    MyServicceModel myService,
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

  static MyServicceModel _fromJson(Map<String, dynamic> json) {
    final myService = MyServicceModel()
      ..id=json['id']
      ..name = json['name']
      ..userId = json['userId']
      ..deletedAt = json['deletedAt']
      ..createdAt = json['createdAt']
      ..money = json['money']
      ..updateAt = json['updateAt'];
    return myService;
  }
}
