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
  String? phoneNumber;
  String? name;
  num? money;
  bool isBooking;
  bool isIncome;
  int? idCategory;
  MyBookingPramsApi({
    this.isBooking = false,
    this.isIncome=false,
    this.myCustomerId,
    this.myServices,
    this.address,
    this.date,
    this.discount,
    this.note,
    this.status,
    this.id,
    this.idCategory,
    this.money,
    this.name,
    this.phoneNumber,
  });
}

class BookingApi {
  Future<Result<List<MyBookingModel>, Exception>> postBooking(
    MyBookingPramsApi? prams,
  ) async {
    try {
      final response = await HttpRemote.post(
        url: '/my-booking',
        body: {
          'myCustomerId': prams!.myCustomerId,
          'money': prams.money,
          'address': prams.address,
          'date': prams.date,
          'note': prams.note,
          'isBooking': prams.isBooking,
          'income': prams.isIncome,
          'categoryId': prams.idCategory,
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
          'address': prams.address,
          'note': prams.note,
          'date': prams.date,
          'money': prams.money,
          'fullName': prams.name,
          'phoneNumber': prams.phoneNumber,
          'categoryId': prams.idCategory,
          'myCustomerId': prams.myCustomerId,
          'status': 'Confirmed',
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
}
