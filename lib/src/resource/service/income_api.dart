// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';
import '../model/revenue_chart_model.dart';

class IncomeParams {
  const IncomeParams({
    this.id,
    this.page, 
    this.startDate,
    this.timeZone,
    this.endDate
  });
  final int? id;
  final int? page;
  final String? startDate;
  final String? timeZone;
  final String? endDate;
}

class IncomeApi {
  Future<Result<StatisticsModel, Exception>> getIncome(
      IncomeParams params,) async {
    try {
      final response = await HttpRemote.get(
        url: '/income/statistics?currentDate=${DateTime.now()}&timeZone=${params.timeZone}',
      );
      print(response?.statusCode);
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']);
          final income = StatisticsModelFactory.create(data);
          return Success(income);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<RevenueChartModel>, Exception>> getRevenueChart(
      IncomeParams params,) async {
    try {
      final response = await HttpRemote.get(
        url: '/income?paymentStatus=Paid&timeZone=${params.timeZone}&startDate=${params.startDate}&endDate=${params.endDate}',
      );
      print(response?.statusCode);
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final income = RevenueChartModelFactory.createList(data);
          return Success(income);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<RevenueChartModel>, Exception>> getTopRevenue(
      IncomeParams params,) async {
    try {
      final response = await HttpRemote.get(
        url: '/income/top-service?date=${params.startDate}',
      );
      print(response?.statusCode);
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final income = RevenueChartModelFactory.createList(data);
          return Success(income);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
