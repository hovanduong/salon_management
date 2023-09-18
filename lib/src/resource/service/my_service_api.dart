// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';
import 'auth.dart';

class MyServiceApi {
  Future<Result<List<MyServiceModel>, Exception>> getService() async {
    try {
      final response = await HttpRemote.get(
        url: '/my-service',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final service = MyServiceFactory.createList(data);
          return Success(service);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> postService(AuthParams? params) async {
    try {
      final response = await HttpRemote.post(
        url: '/my-service',
        body: {
          'name': params!.myServiceModel!.name,
          'money': params.myServiceModel!.money,
          'categories': params.listCategory
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

  Future<Result<bool, Exception>> deleteService(int id) async {
    try {
      final response = await HttpRemote.delete(
        url: '/my-service/$id',
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
}
