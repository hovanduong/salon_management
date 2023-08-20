// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class UserModel {
  String? phone;
  String? firstName;
  String? lastName;
  String? middleName;
  String? avatar;
  String? birthDate;

  UserModel({
    this.phone,
    this.firstName,
    this.lastName,
    this.middleName,
    this.avatar,
    this.birthDate,
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
    data['phone'] = userModel.phone;
    data['firstName'] = userModel.firstName;
    data['lastName'] = userModel.lastName;
    data['middleName'] = userModel.middleName;
    data['avatar'] = userModel.avatar;
    data['birthDate'] = userModel.birthDate;

    return data;
  }

  static UserModel _fromJson(Map<String, dynamic> json) {
    final userModel = UserModel()
      ..phone = json['phone']
      ..firstName = json['firstName']
      ..lastName = json['lastName']
      ..middleName = json['middleName']
      ..avatar = json['avatar']
      ..birthDate = json['birthDate'];
    return userModel;
  }
}
