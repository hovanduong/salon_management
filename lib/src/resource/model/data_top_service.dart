// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

class DataTopService {
  String? nameService;
  num? quantity;
  num? revenue;


  DataTopService({
    this.nameService,
    this.quantity,
    this.revenue,
  });
}

abstract class DataTopServiceFactory {
  static List<DataTopService> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => DataTopServiceFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static DataTopService create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final quantityServiceModel = _fromJson(jsonMap);
    return quantityServiceModel;
  }

  static String toJson(DataTopService model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    DataTopService quantityServiceModel,
  ) {
    final data = <String, dynamic>{};
    data['nameService'] = quantityServiceModel.nameService;
    data['quantity'] = quantityServiceModel.quantity;

    return data;
  }

  static DataTopService _fromJson(Map<String, dynamic> json) {
    final quantityService = DataTopService()
      ..nameService = json['nameService']
      ..quantity = json['quantity'];
    return quantityService;
  }
}
