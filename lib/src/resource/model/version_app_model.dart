// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class VersionAppModel {
  num? id;
  bool? newVersion;

  VersionAppModel({
    this.id,
    this.newVersion,
  });
}

abstract class VersionAppFactory {
  static List<VersionAppModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => VersionAppFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static VersionAppModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final userModel = _fromJson(jsonMap);
    return userModel;
  }

  static String toJson(VersionAppModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    VersionAppModel userModel,
  ) {
    final data = <String, dynamic>{};
    data['id'] = userModel.id;
    data['newVersion'] = userModel.newVersion;

    return data;
  }

  static VersionAppModel _fromJson(Map<String, dynamic> json) {
    final userModel = VersionAppModel()
      ..id = json['id']
      ..newVersion = json['phoneNumber'];
    return userModel;
  }
}
