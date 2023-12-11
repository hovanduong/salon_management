// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

class TotalDebtModel {
  num? totalDebtMe;
  num? totalPaidMe;
  num? totalPaidUser;
  num? totalDebtUser;

  TotalDebtModel({
    this.totalDebtMe,
    this.totalPaidUser,
    this.totalPaidMe,
    this.totalDebtUser,
  });
}

abstract class TotalDebtModelFactory {
  static List<TotalDebtModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => TotalDebtModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static TotalDebtModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final incomeModel = _fromJson(jsonMap);
    return incomeModel;
  }

  static String toJson(TotalDebtModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    TotalDebtModel incomeModel,
  ) {
    final data = <String, dynamic>{};
    data['totalDebtMe'] = incomeModel.totalDebtMe;
    data['totalPaidMe'] = incomeModel.totalPaidMe;
    data['totalPaidUser'] = incomeModel.totalPaidUser;
    data['totalDebtUser'] = incomeModel.totalDebtUser;

    return data;
  }

  static TotalDebtModel _fromJson(Map<String, dynamic> json) {
    final total = TotalDebtModel()
      ..totalDebtMe = json['totalDebtMe'] 
      ..totalPaidMe = json['totalPaidMe'] 
      ..totalPaidUser = json['totalPaidUser'] 
      ..totalDebtUser = json['totalDebtUser'];
    return total;
  }
}
