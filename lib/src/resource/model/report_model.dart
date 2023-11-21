// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'revenue_day_model.dart';


class ReportModel {
  String? date;
  List<RevenueDayModel>? revenueDay;
  bool isCurrentDay;

  ReportModel({
    this.revenueDay,
    this.date,
    this.isCurrentDay=false
  });
}

abstract class ReportModelFactory {
  static List<ReportModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as Map<String, dynamic>; 
    final models=
    rawModels.entries
      .map((rawModel){
        return ReportModelFactory._fromJson(rawModel);
      }).toList();

        // .map((rawModel) => ReportModelFactory._fromJson(rawModel))
        // .toList();
    return models;
  }

  // static ReportModel create(String jsonString) {
  //   final jsonMap = jsonDecode(jsonString);
  //   final reportModel = _fromJson(jsonMap);
  //   return reportModel;
  // }

  static String toJson(ReportModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    ReportModel reportModel,
  ) {
    final data = <String, dynamic>{};
    data['revenueDay'] = reportModel.revenueDay;
    data['date'] = reportModel.date;
    //  data['myService'] = ReportModel.myService != null
    //     ? jsonDecode(MyServiceFactory.toJson(ReportModel.myService!))
    //     : null;
    return data;
  }

  static ReportModel _fromJson(MapEntry<String, dynamic> json) {
    final reportModel = ReportModel()
      ..date = json.key
      ..revenueDay = (json.value !=null || json.value !=[]) ? 
        RevenueDayModelFactory.createList(jsonEncode(json.value)): null;
    return reportModel;
  }
}
