// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class OwesInvoiceParams {
  const OwesInvoiceParams({
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

class OwesInvoiceApi {
  Future<Result<List<OwesModel>, Exception>> getOwesInvoice(
    OwesInvoiceParams params,)async {
    try {
      final response = await HttpRemote.get(
        url: '/owes-invoice?pageSize=10&page=${params.page}&myCustomerOwesId=${
          params.id}',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final owes = OwesModelFactory.createList(data);
          return Success(owes);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<OwesTotalModel, Exception>> getTotalOwesInvoice(
    OwesInvoiceParams params,)async {
    try {
      final response = await HttpRemote.get(
        url: '/owes-invoice/total-debt?myCustomerOwesId=${params.id}',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']);
          final owes = OwesTotalModelFactory.create(data);
          return Success(owes);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> deleteCategory(int id) async {
    try {
      final response = await HttpRemote.delete(
        url: '/owes-customer/$id',
      );
      switch (response?.statusCode) {
        case 200:
          return const Success(true);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> putCategory(OwesInvoiceParams? params) async {
    try {
      final response = await HttpRemote.put(
        url: '/owes-customer/${params!.id}',
        body: {
          'fullName': params.fullName,
        },
      );
      switch (response?.statusCode) {
        case 200:
          return const Success(true);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> postDebit(OwesInvoiceParams? params) async {
    try {
      final response = await HttpRemote.post(
        url: '/owes-customer', 
        body: {
          'fullName': params!.fullName,
        },
      );
      print(response?.statusCode);
      switch (response?.statusCode) {
        case 201:
          return const Success(true);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
