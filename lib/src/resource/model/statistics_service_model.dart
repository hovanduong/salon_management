// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

import 'model.dart';

class StatisticsServiceModel {
  TopServiceModel? serviceNameYesterDay;
  TopServiceModel? serviceNameDay;
  TopServiceModel? serviceNameWeek;
  TopServiceModel? serviceNameMonth;

  StatisticsServiceModel({
    this.serviceNameYesterDay,
    this.serviceNameWeek,
    this.serviceNameDay,
    this.serviceNameMonth,
  });
}

abstract class StatisticsServiceModelFactory {
  static List<StatisticsServiceModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => StatisticsServiceModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static StatisticsServiceModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final incomeModel = _fromJson(jsonMap);
    return incomeModel;
  }

  static String toJson(StatisticsServiceModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    StatisticsServiceModel incomeModel,
  ) {
    final data = <String, dynamic>{};
    data['serviceNameYesterDay'] = incomeModel.serviceNameYesterDay;
    data['serviceNameDay'] = incomeModel.serviceNameDay;
    data['serviceNameWeek'] = incomeModel.serviceNameWeek;
    data['serviceNameMonth'] = incomeModel.serviceNameMonth;

    return data;
  }

  static StatisticsServiceModel _fromJson(Map<String, dynamic> json) {
    final income = StatisticsServiceModel()
      ..serviceNameYesterDay = json['serviceNameYesterDay'] != null
        ? TopServiceModelFactory.create(jsonEncode(json['serviceNameYesterDay']))
        : null
      ..serviceNameDay = json['serviceNameDay'] != null
        ? TopServiceModelFactory.create(jsonEncode(json['serviceNameDay']))
        : null
      ..serviceNameWeek = json['serviceNameWeek'] != null
        ? TopServiceModelFactory.create(jsonEncode(json['serviceNameWeek']))
        : null
      ..serviceNameMonth = json['serviceNameMonth'] != null
        ? TopServiceModelFactory.create(jsonEncode(json['serviceNameMonth']))
        : null;
    return income;
  }
}
