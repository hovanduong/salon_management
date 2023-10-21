// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'model.dart';

class AuthModel {
  String? accessToken;
  UserModel? userModel;

  AuthModel({
    this.accessToken,
    this.userModel,
  });
}

abstract class AuthModelFactory {
  static List<AuthModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => AuthModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static AuthModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final authModel = _fromJson(jsonMap);
    return authModel;
  }

  static String toJson(AuthModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    AuthModel authModel,
  ) {
    final data = <String, dynamic>{};
    data['accessToken'] = authModel.accessToken;
    data['email'] = authModel.userModel;

    return data;
  }

  static AuthModel _fromJson(Map<String, dynamic> json) {
    final authModel = AuthModel()
      ..userModel = json['user'] != null 
        ? UserModelFactory.create(jsonEncode(json['user'])) : null
      ..accessToken = json['accessToken'];
    return authModel;
  }
}
