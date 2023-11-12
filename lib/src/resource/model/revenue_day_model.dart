// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class RevenueDayModel {
  num? money;
  bool? income;

  RevenueDayModel({
    this.money,
    this.income,
  });
}

abstract class RevenueDayModelFactory {
  static List<RevenueDayModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => RevenueDayModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static RevenueDayModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final revenueDayModel = _fromJson(jsonMap);
    return revenueDayModel;
  }

  static String toJson(RevenueDayModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    RevenueDayModel revenueDayModel,
  ) {
    final data = <String, dynamic>{};
    data['money'] = revenueDayModel.money;
    data['income'] = revenueDayModel.income;
    //  data['myService'] = RevenueDayModel.myService != null
    //     ? jsonDecode(MyServiceFactory.toJson(RevenueDayModel.myService!))
    //     : null;
    return data;
  }

  static RevenueDayModel _fromJson(Map<String, dynamic> json) {
    final myBooking = RevenueDayModel()
      ..money = json['money']
      ..income=json['income'];
    return myBooking;
  }
}
