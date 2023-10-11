// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

import 'quantity_income_model.dart';

class IncomeModel {
  QuantityIncomeModel? revenue;
  QuantityIncomeModel? appointmentConfirmedCount;
  QuantityIncomeModel? appointmentCanceledCount;
  QuantityIncomeModel? customerCount;
  bool showRevenue;
  bool showTopService;
  bool showTopServicePackage;

  IncomeModel({
    this.revenue,
    this.appointmentCanceledCount,
    this.appointmentConfirmedCount,
    this.customerCount,
    this.showRevenue=false,
    this.showTopService=false,
    this.showTopServicePackage=false,
  });
}

abstract class IncomeModelFactory {
  static List<IncomeModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => IncomeModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static IncomeModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final incomeModel = _fromJson(jsonMap);
    return incomeModel;
  }

  static String toJson(IncomeModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    IncomeModel incomeModel,
  ) {
    final data = <String, dynamic>{};
    data['revenue'] = incomeModel.revenue;
    data['appointmentConfirmedCount'] = incomeModel.appointmentConfirmedCount;
    data['appointmentCanceledCount'] = incomeModel.appointmentCanceledCount;
    data['customerCount'] = incomeModel.customerCount;

    return data;
  }

  static IncomeModel _fromJson(Map<String, dynamic> json) {
    final income = IncomeModel()
      ..revenue = json['revenue'] != null
        ? QuantityIncomeModelFactory.create(jsonEncode(json['revenue']))
        : null
      ..appointmentConfirmedCount = json['appointmentConfirmedCount'] != null
        ? QuantityIncomeModelFactory.create(jsonEncode(json['appointmentConfirmedCount']))
        : null
      ..appointmentCanceledCount = json['appointmentCanceledCount'] != null
        ? QuantityIncomeModelFactory.create(jsonEncode(json['appointmentCanceledCount']))
        : null
      ..customerCount = json['customerCount'] != null
        ? QuantityIncomeModelFactory.create(jsonEncode(json['customerCount']))
        : null;
    return income;
  }
}
