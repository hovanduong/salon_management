// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class IncomeParams {
  const IncomeParams(
      {this.id, this.page, this.startDate, this.timeZone, this.endDate, this.date});
  final int? id;
  final int? page;
  final DateTime? date;
  final String? startDate;
  final String? timeZone;
  final String? endDate;
}

class IncomeApi {
  Future<Result<StatisticsModel, Exception>> getIncome(
    IncomeParams params,
  ) async {
    try {
      final response = await HttpRemote.get(
        url:
            '/income/statistics?currentDate=${DateTime.now()}&timeZone=${params.timeZone}',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']);
          final income = StatisticsModelFactory.create(data);
          return Success(income);
        case 401:
          await HttpRemote.logOut(response!.statusCode);
          return Failure(Exception(response.reasonPhrase));
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<RevenueChartModel>, Exception>> getRevenueChart(
    IncomeParams params,
  ) async {
    try {
      final response = await HttpRemote.get(
        url:
            '/income?paymentStatus=Paid&timeZone=${params.timeZone}&startDate=${params.startDate}&endDate=${params.endDate}',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final income = RevenueChartModelFactory.createList(data);
          return Success(income);
        case 401:
          await HttpRemote.logOut(response!.statusCode);
          return Failure(Exception(response.reasonPhrase));
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<StatisticsServiceModel, Exception>> getTopRevenue(
    IncomeParams params,
  ) async {
    try {
      final response = await HttpRemote.get(
        url: '/income/top-service?date=${params.startDate}',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final income = StatisticsServiceModelFactory.create(data);
          return Success(income);
        case 401:
          await HttpRemote.logOut(response!.statusCode);
          return Failure(Exception(response.reasonPhrase));
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
