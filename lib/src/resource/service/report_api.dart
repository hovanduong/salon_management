// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class ReportParams {
  const ReportParams({
    this.id,
    this.timeZone, 
    this.date, 
  });
  final int? id;
  final String? timeZone;
  final String? date;

}

class ReportApi {
  Future<Result<List<ReportModel>, Exception>> getReport(ReportParams params) 
    async {
    try {
      final response = await HttpRemote.get(
        url: '/report?date=${params.date}&timeZone=${params.timeZone}',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']) ;
          final revenue = ReportModelFactory.createList(data);
          return Success(revenue);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
  Future<Result<List<ExpenseManagementModel>, Exception>> getExpenseManagement(
    ReportParams params,) async {
    try {
      final response = await HttpRemote.get(
        url: '/report/expense-management?date=${params.date}&timeZone=${params.timeZone}',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']) ;
          final revenue = ExpenseManagementModelFactory.createList(data);
          return Success(revenue);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
