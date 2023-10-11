// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

class TopServiceModel {
  String? nameService;
  String? date;
  double? dailyRevenue;

  TopServiceModel({
    this.nameService,
    this.dailyRevenue,
    this.date,
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
    data['nameService'] = revenueChartModel.nameService;
    data['date'] = revenueChartModel.date;
    data['dailyRevenue'] = revenueChartModel.dailyRevenue;

    return data;
  }

  static TopServiceModel _fromJson(Map<String, dynamic> json) {
    final revenueChart = TopServiceModel()
      ..nameService = json['nameService']
      ..date = json['date'] 
      ..dailyRevenue = double.parse(json['dailyRevenue']);
    return revenueChart;
  }
}
