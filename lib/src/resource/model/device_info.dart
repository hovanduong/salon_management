// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class DeviceInfoModel {
  num? id;
  String? deviceID;
  String? deviceName;
  String? deviceVersion;
  String? os;

  DeviceInfoModel({
    this.id,
    this.deviceID,
    this.deviceName,
    this.deviceVersion,
    this.os,
  });
}

abstract class DeviceInfoFactory {
  static List<DeviceInfoModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => DeviceInfoFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static DeviceInfoModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final userModel = _fromJson(jsonMap);
    return userModel;
  }

  static String toJson(DeviceInfoModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    DeviceInfoModel userModel,
  ) {
    final data = <String, dynamic>{};
    data['id'] = userModel.id;
    data['deviceID'] = userModel.deviceID;
    data['deviceName'] = userModel.deviceName;
    data['deviceVersion'] = userModel.deviceVersion;
    data['os'] = userModel.os;
    return data;
  }

  static DeviceInfoModel _fromJson(Map<String, dynamic> json) {
    final userModel = DeviceInfoModel()
      ..deviceID = json['deviceID']
      ..deviceName = json['deviceName']
      ..deviceVersion = json['deviceVersion']
      ..os = json['os']
      ..id = json['id'];
    return userModel;
  }
}
