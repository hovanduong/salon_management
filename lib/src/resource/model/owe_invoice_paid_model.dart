// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'model.dart';

class OwesPaidModel {
  int? debitId;
  num? totalMoneyIsDebitTrue;
  num? totalMoneyIsDebitFalse;
  bool? isMe;
  bool? isUser;
  List<OwesModel>? invoices;
  OwesPaidModel({
    this.totalMoneyIsDebitTrue,
    this.totalMoneyIsDebitFalse,
    this.isMe,
    this.isUser,
    this.debitId,
    this.invoices,
  });
}

abstract class OwesPaidModelFactory {
  static List<OwesPaidModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => OwesPaidModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static OwesPaidModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final owesPaidModel = _fromJson(jsonMap);
    return owesPaidModel;
  }

  static String toJson(OwesPaidModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    OwesPaidModel myCustomer,
  ) {
    final data = <String, dynamic>{};
    data['totalMoneyIsDebitTrue'] = myCustomer.totalMoneyIsDebitTrue;
    return data;
  }

  static OwesPaidModel _fromJson(Map<String, dynamic> json) {
    final owes = OwesPaidModel()
      ..totalMoneyIsDebitTrue = json['totalMoneyIsDebitTrue']
      ..totalMoneyIsDebitFalse = json['totalMoneyIsDebitFalse']
      ..isMe = json['isMe']
      ..isUser = json['isUser']
      ..debitId = json['debitId']
      ..invoices = json['invoices'] !=null ? 
         OwesModelFactory.createList(jsonEncode(json['invoices'])) 
        : null;
    return owes;
  }
}
