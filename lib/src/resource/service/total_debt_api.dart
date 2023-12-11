// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class TotalDebitParams {
  const TotalDebitParams({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.page,
    this.gender,
    this.search,
  });
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final int? page;
  final String? email;
  final String? gender;
  final String? search;
}

class TotalDebitApi {
  Future<Result<TotalDebtModel, Exception>> getTotalDebit()
   async {
    try {
      final response = await HttpRemote.get(
        url: '/owes-invoice/all-total-debt',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']);
          final totalDebt = TotalDebtModelFactory.create(data);
          return Success(totalDebt);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
