// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class MyCostomerModel {
  int? id;
  String? phoneNumber;
  String? fullName;
  String? gender;
  String? email;
  int? userId;
  String? deletedAt;
  String? updateAt;
  String? createdAt;
  MyCostomerModel({
    this.id,
    this.phoneNumber,
    this.fullName,
    this.gender,
    this.email,
    this.userId,
    this.createdAt,
    this.deletedAt,
    this.updateAt,
  });
}

abstract class MyCostomerModelFactory {
  static List<MyCostomerModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => MyCostomerModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static MyCostomerModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final myCostomerModel = _fromJson(jsonMap);
    return myCostomerModel;
  }

  static String toJson(MyCostomerModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    MyCostomerModel myCostomer,
  ) {
    final data = <String, dynamic>{};
    data['phoneNumber'] = myCostomer.phoneNumber;
    data['fullName'] = myCostomer.fullName;
    data['gender'] = myCostomer.gender;
    data['email'] = myCostomer.email;
    data['userId'] = myCostomer.userId;
    data['createdAt'] = myCostomer.createdAt;
    data['deletedAt'] = myCostomer.deletedAt;
    data['updateAt'] = myCostomer.updateAt;

    return data;
  }

  static MyCostomerModel _fromJson(Map<String, dynamic> jsons) {
    final myCostomer = MyCostomerModel()
      ..id = jsons['id']
      ..phoneNumber = jsons['phoneNumber']
      ..fullName = jsons['fullName']
      ..gender = jsons['gender']
      ..email = jsons['email']
      ..userId = jsons['userId']
      ..createdAt = jsons['createdAt']
      ..deletedAt = jsons['deletedAt']
      ..updateAt = jsons['updateAt'];
    return myCostomer;
  }
}
