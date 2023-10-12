// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

// import 'model.dart';

class TopServiceModel {
  Map<String, dynamic>? serviceCounts;
  Map<String, dynamic>? serviceMoney;

  TopServiceModel({
    this.serviceCounts,
    this.serviceMoney,
  });
}

abstract class TopServiceModelFactory {
  static List<TopServiceModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => TopServiceModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static TopServiceModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final revenueChartModel = _fromJson(jsonMap);
    return revenueChartModel;
  }

  static String toJson(TopServiceModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    TopServiceModel revenueChartModel,
  ) {
    final data = <String, dynamic>{};
    data['serviceCounts'] = revenueChartModel.serviceCounts;
    data['serviceMoney'] = revenueChartModel.serviceMoney;

    return data;
  }

  static TopServiceModel _fromJson(Map<String, dynamic> json) {
    final revenueChart = TopServiceModel()
      ..serviceCounts = json['serviceCounts'] 
      ..serviceMoney = json['serviceMoney'];
    return revenueChart;
  }
}
