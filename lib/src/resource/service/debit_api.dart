// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class DebitParams {
  const DebitParams({
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

class DebitApi {
  Future<Result<List<MyCustomerModel>, Exception>> getDebit(DebitParams params)
   async {
    try {
      final response = await HttpRemote.get(
        url: '/owes-customer?pageSize=20&page=${params.page}&search=${params.search}',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final myCustomer = MyCustomerModelFactory.createList(data);
          return Success(myCustomer);
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

  Future<Result<bool, Exception>> putCategory(DebitParams? params) async {
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

  Future<Result<bool, Exception>> postDebit(DebitParams? params) async {
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
