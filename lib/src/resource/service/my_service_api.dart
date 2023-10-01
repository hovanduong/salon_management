// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class ServiceParams {
  const ServiceParams({
    this.id,
    this.name,
    this.listCategory,
    this.money, 
  });
  final int? id;
  final String? name;
  final List<int>? listCategory;
  final num? money;
}

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

  Future<Result<bool, Exception>> postService(ServiceParams? params) async {
    try {
      final response = await HttpRemote.post(
        url: '/my-service',
        body: {
          'name': params!.name,
          'money': params.money,
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

  Future<Result<bool, Exception>> deleteService(int idCategory, int idService) async {
    try {
      final response = await HttpRemote.delete(
        url: '/my-service/$idService/$idCategory',
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
