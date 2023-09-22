// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';
import 'auth.dart';

class MyCustomerApi {
  Future<Result<List<MyCustomerModel>, Exception>> getMyCustomer() async {
    try {
      final response = await HttpRemote.get(
        url: '/my-customer',
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
      print(response?.statusCode);
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

  Future<Result<bool, Exception>> putMyCustomer(AuthParams? params) async {
    try {
      final response = await HttpRemote.put(
        url: '/my-customer/${params!.myCustomerModel!.id}',
        body: {
          'fullName': params.myCustomerModel!.fullName,
          'email': params.myCustomerModel!.email,
          'gender': params.myCustomerModel!.gender,
        },
      );
      print(response?.statusCode);
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

  Future<Result<bool, Exception>> postMyCustomer(AuthParams params) async {
    try {
      final response = await HttpRemote.post(
        url: '/my-customer', 
        body: {
          'phoneNumber': params.phoneNumber,
          'fullName': params.name
        }
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
