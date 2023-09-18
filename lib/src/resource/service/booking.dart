// ignore_for_file: avoid_dynamic_calls


import '../../configs/configs.dart';
import '../../utils/http_remote.dart';

import '../model/my_booking_model.dart';


class BookingApi {
  Future<Result<bool, Exception>> postBooking(MyBookingModel? booking) async {
    try {
      final response = await HttpRemote.post(
        url: '/api/my-booking',
        body: {
          'myCustomerId': booking!.userId,
          'myServices': booking.myServices,
          'address': booking.address,
          'date': booking.date,
          'note': booking.note
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
}
