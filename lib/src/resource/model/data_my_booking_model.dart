// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

import 'model.dart';

class DataMyBookingModel {
  num? totalItems;
  List<MyBookingModel>? items;


  DataMyBookingModel({
    this.items,
    this.totalItems,
  });
}

abstract class DataMyBookingModelFactory {
  static List<DataMyBookingModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => DataMyBookingModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static DataMyBookingModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final totalItemsServiceModel = _fromJson(jsonMap);
    return totalItemsServiceModel;
  }

  static String toJson(DataMyBookingModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    DataMyBookingModel totalItemsServiceModel,
  ) {
    final data = <String, dynamic>{};
    data['items'] = totalItemsServiceModel.items;
    data['totalItems'] = totalItemsServiceModel.totalItems;

    return data;
  }

  static DataMyBookingModel _fromJson(Map<String, dynamic> json) {
    final totalItemsService = DataMyBookingModel()
      ..items = json['items'] != null
      ? MyBookingModelFactory.createList(jsonEncode(json['items'])): null
      ..totalItems = json['totalItems'];
    return totalItemsService;
  }
}
