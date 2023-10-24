// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/invoice_model.dart';

class InvoiceParams {
  const InvoiceParams({
    this.id,
    this.page,
    this.status,
    this.isButtonBookingDetails = false,
  });
  final int? id;
  final int? page;
  final String? status;
  final bool isButtonBookingDetails;
}

class InvoiceApi {
  Future<Result<bool, Exception>> postInvoice(
    InvoiceParams params,
  ) async {
    try {
      final response = await HttpRemote.post(
        url: '/invoice',
        body: {
          'myBookingId': params.id,
          'discount': 0,
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

  Future<Result<List<InvoiceModel>, Exception>> getInvoice(
    InvoiceParams params,
  ) async {
    try {
      final response = await HttpRemote.get(
        url: '/invoice?pageSize=10&page=${params.page}&paymentStatus=Paid',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final invoice = InvoiceModelFactory.createList(data);
          return Success(invoice);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> deleteInvoice(int id,) async {
    try {
      final response = await HttpRemote.delete(
        url: '/invoice/$id',
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
