// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/my_booking_model.dart';
import 'auth.dart';

class MyBookingApi{
  Future<Result<List<MyBookingModel>, Exception>> getMyBooking(AuthParams params) async {
    try {
      final response = await HttpRemote.get(
        url: '/my-booking?pageSize=${params.pageSize}&page=${params.page}',
      );
      print(response?.statusCode);
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final myBooking = MyBookingModelFactory.createList(data);
          return Success(myBooking);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}