// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

class OwesTotalModel {
  num? paidUser;
  num? paidMe;
  num? oweUser;
  bool? isMe;
  bool? isUser;
  num? oweMe;
 
  OwesTotalModel({
    this.paidUser,
    this.paidMe,
    this.oweUser,
    this.isMe,
    this.isUser,
    this.oweMe,
  });
}

abstract class OwesTotalModelFactory {
  static List<OwesTotalModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => OwesTotalModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static OwesTotalModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final owesTotalModel = _fromJson(jsonMap);
    return owesTotalModel;
  }

  static String toJson(OwesTotalModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    OwesTotalModel myCustomer,
  ) {
    final data = <String, dynamic>{};
    data['paidMe'] = myCustomer.paidMe;
    return data;
  }

  static OwesTotalModel _fromJson(Map<String, dynamic> json) {
    final owes = OwesTotalModel()
      ..paidUser = json['paidUser']
      ..paidMe = json['paidMe']
      ..oweUser = json['oweUser']
      ..isMe = json['isMe']
      ..isUser = json['isUser']
      ..oweMe = json['oweMe'];
    return owes;
  }
}
