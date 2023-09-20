// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

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
}
