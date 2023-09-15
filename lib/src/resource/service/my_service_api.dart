// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class MyServiceApi {
  Future<Result<List<MyServiceModel>, Exception>> getService() async {
    try {
      final response = await HttpRemote.get(
        url: '/my-service?pageSize=10&page=1',
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
}
