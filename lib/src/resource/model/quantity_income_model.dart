// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

class QuantityIncomeModel {
  num? currentCount;
  num? beforeCount;
  num? pctInc;


  QuantityIncomeModel({
    this.currentCount,
    this.beforeCount,
    this.pctInc,
  });
}

abstract class QuantityIncomeModelFactory {
  static List<QuantityIncomeModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => QuantityIncomeModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static QuantityIncomeModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final quantityIncomeModel = _fromJson(jsonMap);
    return quantityIncomeModel;
  }

  static String toJson(QuantityIncomeModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    QuantityIncomeModel quantityIncomeModel,
  ) {
    final data = <String, dynamic>{};
    data['currentCount'] = quantityIncomeModel.currentCount;
    data['beforeCount'] = quantityIncomeModel.beforeCount;
    data['pctInc'] = quantityIncomeModel.pctInc;

    return data;
  }

  static QuantityIncomeModel _fromJson(Map<String, dynamic> json) {
    final quantityIncome = QuantityIncomeModel()
      ..currentCount = json['currentCount']
      ..beforeCount = json['beforeCount']
      ..pctInc = json['pctInc'];
    return quantityIncome;
  }
}
