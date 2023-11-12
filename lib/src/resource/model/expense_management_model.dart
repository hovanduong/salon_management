// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class ExpenseManagementModel {
  num? money;
  bool? revenue;
  bool? income;

  ExpenseManagementModel({
    this.money,
    this.income,
    this.revenue,
  });
}

abstract class ExpenseManagementModelFactory {
  static List<ExpenseManagementModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => ExpenseManagementModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static ExpenseManagementModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final expenseManagementModel = _fromJson(jsonMap);
    return expenseManagementModel;
  }

  static String toJson(ExpenseManagementModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    ExpenseManagementModel expenseManagementModel,
  ) {
    final data = <String, dynamic>{};
    data['money'] = expenseManagementModel.money;
    data['income'] = expenseManagementModel.income;
    data['revenue'] = expenseManagementModel.revenue;
    //  data['myService'] = ExpenseManagementModel.myService != null
    //     ? jsonDecode(MyServiceFactory.toJson(ExpenseManagementModel.myService!))
    //     : null;
    return data;
  }

  static ExpenseManagementModel _fromJson(Map<String, dynamic> json) {
    final expense = ExpenseManagementModel()
      ..money = json['money']
      ..revenue = json['revenue']
      ..income=json['income'];
    return expense;
  }
}
