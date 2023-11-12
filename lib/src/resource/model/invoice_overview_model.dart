// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

import 'invoice_model.dart';

class InvoiceOverViewModel {
  int? totalIncomeMoney;
  String? date;
  int? totalNotIncomeMoney;
  List<InvoiceModel>? invoices;

  InvoiceOverViewModel({
    this.totalIncomeMoney,
    this.invoices,
    this.totalNotIncomeMoney,
    this.date,
  });
}

abstract class InvoiceOverViewModelFactory {
  static List<InvoiceOverViewModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => InvoiceOverViewModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static InvoiceOverViewModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final invoiceOverViewModel = _fromJson(jsonMap);
    return invoiceOverViewModel;
  }

  static String toJson(InvoiceOverViewModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    InvoiceOverViewModel invoiceOverViewModel,
  ) {
    final data = <String, dynamic>{};
    data['totalIncomeMoney'] = invoiceOverViewModel.totalIncomeMoney;

    return data;
  }

  static InvoiceOverViewModel _fromJson(Map<String, dynamic> json) {
    final invoice = InvoiceOverViewModel()
      ..date = json['date']
      ..totalIncomeMoney = json['totalIncomeMoney']
      ..totalNotIncomeMoney = json['totalNotIncomeMoney']
      ..invoices = json['invoices'] != null
          ? InvoiceModelFactory.createList(jsonEncode(json['invoices']))
          : null;
    return invoice;
  }
}
