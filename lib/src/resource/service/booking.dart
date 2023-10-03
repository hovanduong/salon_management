// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/my_booking_model.dart';

class MyBookingPramsApi {
  int? id;
  int? myCustomerId;
  List<int>? myServices;
  String? address;
  String? date;
  num? discount;
  String? status;
  String? note;
  bool isBooking;
  MyBookingPramsApi({
    this.isBooking=false,
    this.myCustomerId,
    this.myServices,
    this.address,
    this.date,
    this.discount,
    this.note,
    this.status,
    this.id,
  });
}

class BookingApi {
  Future<Result<List<MyBookingModel>, Exception>> postBooking(
    MyBookingPramsApi? prams) async {
    try {
      final response = await HttpRemote.post(
        url: '/my-booking',
        body: {
          'myCustomerId': prams!.myCustomerId,
          'myServices': prams.myServices,
          'address': prams.address,
          'date': prams.date,
          'note': prams.note,
          'isBooking': prams.isBooking,
        },
      );
      switch (response?.statusCode) {
        case 201:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']);
          final listMyBooking = MyBookingModelFactory.createList(data);
          return Success(listMyBooking);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> putBooking(MyBookingPramsApi? prams) async {
    try {
      final response = await HttpRemote.put(
        url: '/my-booking/${prams!.id}',
        body: {
          'myServices': prams.myServices,
          'address': prams.address,
          'date': prams.date,
          'note': prams.note,
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
}
