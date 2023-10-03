// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/my_booking_model.dart';

class MyBookingParams {
  const MyBookingParams({
    this.id,
    this.page, 
    this.status,
    this.isPayment=false,
  });
  final int? id;
  final int? page;
  final String? status;
  final bool isPayment;
}

class MyBookingApi {
  Future<Result<List<MyBookingModel>, Exception>> getMyBooking(
      MyBookingParams params,) async {
    try {
      final response = await HttpRemote.get(
        url:
            '/my-booking?pageSize=10&page=${params.page}&status=${params.status}',
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

  Future<Result<List<MyBookingModel>, Exception>> getMyBookingUser(
      String id,) async {
    try {
      final response = await HttpRemote.get(
        url: '/my-booking/$id',
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

  Future<Result<bool, Exception>> putStatusAppointment(
      MyBookingParams params,) async {
    try {
      final response = await HttpRemote.put(
        url: '/my-booking/${params.id}/Canceled',
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

  Future<Result<bool, Exception>> deleteBookingHistory(
      MyBookingParams params,) async {
    try {
      final response = await HttpRemote.delete(
        url: '/my-booking/${params.id}',
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
