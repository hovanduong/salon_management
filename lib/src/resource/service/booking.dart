// ignore_for_file: avoid_dynamic_calls

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';

class MyBookingPramsApi {
  int? id;
  int? myCustomerId;
  List<int>? myServices;
  String? address;
  String? date;
  num? discount;
  String? status;
  String? note;
  MyBookingPramsApi({
    this.myCustomerId,
    this.myServices,
    this.address,
    this.date,
    this.discount,
    this.note,
    this.status,
    this.id
  });
}

class BookingApi {
  Future<Result<bool, Exception>> postBooking(MyBookingPramsApi? prams) async {
    try {
      final response = await HttpRemote.post(
        url: '/my-booking',
        body: {
          'myCustomerId': prams!.myCustomerId,
          'myServices': prams.myServices,
          'address': prams.address,
          'date': prams.date,
          'note': prams.note
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

  Future<Result<bool, Exception>> putBooking(MyBookingPramsApi? prams) async {
    try {
      final response = await HttpRemote.put(
        url: '/my-booking/${prams!.id}',
        body: {
          'myServices': prams.myServices,
          'address': prams.address,
          'date': prams.date,
          'note': prams.note
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
