// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class MetaDataModel {
  int? appointmentId;
  MetaDataModel({
    this.appointmentId,
  });
}

abstract class MetaDataModelFactory {
  static List<MetaDataModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => MetaDataModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static MetaDataModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final metaDataModel = _fromJson(jsonMap);
    return metaDataModel;
  }

  static String toJson(MetaDataModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    MetaDataModel myCustomer,
  ) {
    final data = <String, dynamic>{};
    return data;
  }

  static MetaDataModel _fromJson(Map<String, dynamic> json) {
    final myCustomer = MetaDataModel()
      ..appointmentId = json['appointmentId'];
    return myCustomer;
  }
}
