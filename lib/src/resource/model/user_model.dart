// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class UserModel {
  String? fullName;
  String? gender;
  String? phoneNumber;
  String? password;
  String? email;
  String? passwordConfirm;
  num? id;

  UserModel({
    this.id,
    this.phoneNumber,
    this.fullName,
    this.gender,
    this.password,
    this.email, 
    this.passwordConfirm,
  });
}

abstract class UserModelFactory {
  static List<UserModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => UserModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static UserModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final userModel = _fromJson(jsonMap);
    return userModel;
  }

  static String toJson(UserModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    UserModel userModel,
  ) {
    final data = <String, dynamic>{};
    data['phoneNumber'] = userModel.phoneNumber;
    data['fullName'] = userModel.fullName;
    data['email'] = userModel.email;
    data['gender'] = userModel.gender;
    data['id'] = userModel.id;

    return data;
  }

  static UserModel _fromJson(Map<String, dynamic> json) {
    final userModel = UserModel()
      ..phoneNumber = json['phoneNumber']
      ..fullName = json['fullName']
      ..email = json['email']
      ..gender = json['gender']
      ..id = json['id'];
    return userModel;
  }
}
