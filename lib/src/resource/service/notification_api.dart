// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/model.dart';

class NotificationParams {
  const NotificationParams({
    this.id,
    this.page,
    this.status,
    this.isRemind = false,
    this.date,
    this.timeZone,
    this.isDate,
    this.idBooking,
    this.nameCustomer,
    this.address,
    this.bookingCode,
  });
  final int? id;
  final int? idBooking;
  final String? bookingCode;
  final int? page;
  final String? status;
  final String? nameCustomer;
  final String? address;
  final bool isRemind;
  final String? date;
  final String? timeZone;
  final int? isDate;
}

class NotificationApi {

  Future<Result<List<NotificationModel>, Exception>> getNotification(int page) 
  async {
    try {
      final response = await HttpRemote.get(
        url: '/notification?pageSize=10&page=$page',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final notification = NotificationModelFactory.createList(data);
          return Success(notification);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> getCancelRemind(int id) 
  async {
    try {
      final response = await HttpRemote.get(
        url: '/reminder/cancel-reminder/$id',
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

  Future<Result<bool, Exception>> putReadNotification(int id,) async {
    try {
      final response = await HttpRemote.put(
        url: '/reminder/isRead/$id',
        body: {
          'isRead':true,
          'type':'reminder',
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

  Future<Result<bool, Exception>> postRemindNotification(
    NotificationParams params,
  ) async {
    try {
      final response = await HttpRemote.post(
        url: '/reminder',
        body: {
          'appointmentId': params.idBooking,
          'reminderTime': params.date,
          'customerName': params.nameCustomer,
          'address': params.address,
          'bookingCode': params.bookingCode,
          'isRead': false,
        },
      );
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

  // Future<Result<bool, Exception>> deleteInvoice(int id,) async {
  //   try {
  //     final response = await HttpRemote.delete(
  //       url: '/invoice/$id',
  //     );
  //     print(response?.statusCode);
  //     switch (response?.statusCode) {
  //       case 200:
  //         return const Success(true);
  //       default:
  //         return Failure(Exception(response!.reasonPhrase));
  //     }
  //   } on Exception catch (e) {
  //     return Failure(e);
  //   }
  // }
}
