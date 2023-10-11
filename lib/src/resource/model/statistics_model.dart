// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

import 'model.dart';

class StatisticsModel {
  IncomeModel? statisticsYesterday;
  IncomeModel? statisticsToday;
  IncomeModel? statisticsWeek;
  IncomeModel? statisticsMonth;

  StatisticsModel({
    this.statisticsYesterday,
    this.statisticsWeek,
    this.statisticsToday,
    this.statisticsMonth,
  });
}

abstract class StatisticsModelFactory {
  static List<StatisticsModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => StatisticsModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static StatisticsModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final incomeModel = _fromJson(jsonMap);
    return incomeModel;
  }

  static String toJson(StatisticsModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    StatisticsModel incomeModel,
  ) {
    final data = <String, dynamic>{};
    data['statisticsYesterday'] = incomeModel.statisticsYesterday;
    data['statisticsToday'] = incomeModel.statisticsToday;
    data['statisticsWeek'] = incomeModel.statisticsWeek;
    data['statisticsMonth'] = incomeModel.statisticsMonth;

    return data;
  }

  static StatisticsModel _fromJson(Map<String, dynamic> json) {
    final income = StatisticsModel()
      ..statisticsYesterday = json['statisticsYesterday'] != null
        ? IncomeModelFactory.create(jsonEncode(json['statisticsYesterday']))
        : null
      ..statisticsToday = json['statisticsToday'] != null
        ? IncomeModelFactory.create(jsonEncode(json['statisticsToday']))
        : null
      ..statisticsWeek = json['statisticsWeek'] != null
        ? IncomeModelFactory.create(jsonEncode(json['statisticsWeek']))
        : null
      ..statisticsMonth = json['statisticsMonth'] != null
        ? IncomeModelFactory.create(jsonEncode(json['statisticsMonth']))
        : null;
    return income;
  }
}
