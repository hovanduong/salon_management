// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

class RevenueChartModel {
  String? rowNumber;
  String? date;
  double? dailyRevenue;

  RevenueChartModel({
    this.rowNumber,
    this.dailyRevenue,
    this.date,
  });
}

abstract class RevenueChartModelFactory {
  static List<RevenueChartModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => RevenueChartModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static RevenueChartModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final revenueChartModel = _fromJson(jsonMap);
    return revenueChartModel;
  }

  static String toJson(RevenueChartModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    RevenueChartModel revenueChartModel,
  ) {
    final data = <String, dynamic>{};
    data['rowNumber'] = revenueChartModel.rowNumber;
    data['date'] = revenueChartModel.date;
    data['dailyRevenue'] = revenueChartModel.dailyRevenue;

    return data;
  }

  static RevenueChartModel _fromJson(Map<String, dynamic> json) {
    final revenueChart = RevenueChartModel()
      ..rowNumber = json['rowNumber']
      ..date = json['date'] 
      ..dailyRevenue = double.parse(json['dailyRevenue']);
    return revenueChart;
  }
}
