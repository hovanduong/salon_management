// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class MyCustomerParams {
  const MyCustomerParams({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.page,
    this.email,
    this.gender,
  });
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final int? page;
  final String? email;
  final String? gender;
}

class MyCustomerApi {
  Future<Result<List<MyCustomerModel>, Exception>> getMyCustomer({
    required bool getAll,
    int? page,
    String? search,
  }) async {
    try {
      final response = await HttpRemote.get(
        url: getAll
            ? '/my-customer'
            : '/my-customer?pageSize=10&page=$page&search=${search ?? ''}',
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

  Future<Result<bool, Exception>> deleteMyCustomer(int id) async {
    try {
      final response = await HttpRemote.delete(
        url: '/my-customer/$id',
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

  Future<Result<bool, Exception>> putMyCustomer(
    MyCustomerParams? params,
  ) async {
    try {
      final response = await HttpRemote.put(
        url: '/my-customer/${params!.id}',
        body: {
          'fullName': params.fullName,
          'email': params.email,
          'gender': params.gender,
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

  Future<Result<MyCustomerModel, Exception>> postMyCustomer(
    MyCustomerParams params,
  ) async {
    try {
      final response = await HttpRemote.post(
        url: '/my-customer',
        body: {
          'phoneNumber': '${params.phoneNumber}',
          'fullName': params.fullName,
        },
      );
      switch (response?.statusCode) {
        case 201:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']);
          final customer= MyCustomerModelFactory.create(data);
          return Success(customer);
        // case 400:
        //   final jsonMap = json.decode(response!.body);
        //   final data = json.encode(jsonMap['code']);
        //   return Failure(AppException(data));
        default:
          return Failure(Exception(response!.reasonPhrase!));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
