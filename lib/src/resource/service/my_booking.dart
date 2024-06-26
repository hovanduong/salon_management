// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class MyBookingParams {
  const MyBookingParams({
    this.id,
    this.page,
    this.status,
    this.code,
    this.isPayment = false,
    this.isToday = false,
    this.isDaysBefore = false,
    this.isUpcoming = false,
    this.isInvoice = false,
    this.isRemind = false,
    this.date,
    this.pageSize,
  });
  final int? id;
  final int? page;
  final int? pageSize;
  final String? status;
  final bool isPayment;
  final bool isToday;
  final bool isDaysBefore;
  final bool isUpcoming;
  final DateTime? date;
  final String? code;
  final bool isInvoice;
  final bool isRemind;
}

class MyBookingApi {
  Future<Result<DataMyBookingModel, Exception>> getMyBooking(
    MyBookingParams params,
  ) async {
    try {
      final response = await HttpRemote.get(
        url: params.isDaysBefore
            ? '/my-booking?pageSize=10&page=${params.page}&status=Confirmed&isBefore=true'
            : params.isToday
                ? '/my-booking?pageSize=${params.pageSize}&page=${params.page}&status=Confirmed&isToDay=true'
                : params.isUpcoming
                    ? '/my-booking?pageSize=${params.pageSize}&page=${params.page}&date=${DateTime.now()}&isUpComing=true&status=Confirmed'
                    : '/my-booking?pageSize=10&page=${params.page}&status=${params.status}',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']);
          final myBooking = DataMyBookingModelFactory.create(data);
          return Success(myBooking);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<MyBookingModel>, Exception>> getMyBookingUser(
    String id,
  ) async {
    try {
      final response = await HttpRemote.get(
        url: '/my-booking/${int.tryParse(id)}',
      );
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
    MyBookingParams params,
  ) async {
    try {
      final response = await HttpRemote.put(
        url: '/my-booking/${params.id}/${params.status}',
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

  Future<Result<bool, Exception>> deleteBookingHistory(
    MyBookingParams params,
  ) async {
    try {
      final response = await HttpRemote.delete(
        url: '/my-booking/${params.id}',
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

  Future<Result<bool, Exception>> putRemindBooking(
    MyBookingParams params,
  ) async {
    try {
      final response = await HttpRemote.put(
        url: '/my-booking/update-reminder/${params.id}/${params.isRemind}',
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
}
