// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'Images_model.dart';

class Service {
  int? id;
  String? name;
  String? description;
  int? price;
  String? startTime;
  String? endTime;
  String? createdAt;
  List<Images>? images;

  Service({
    this.id,
    this.name,
    this.description,
    this.price,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.images,
  });
}

abstract class ServiceFactory {
  static List<Service> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => ServiceFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static Service create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final service = _fromJson(jsonMap);
    return service;
  }

  static String toJson(Service model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    Service service,
  ) {
    final data = <String, dynamic>{};
    data['name'] = service.name;
    data['description'] = service.description;
    data['price'] = service.price;
    data['startTime'] = service.startTime;
    data['endTime'] = service.endTime;
    data['createdAt'] = service.createdAt;
    data['images'] = service.images;
    return data;
  }

  static Service _fromJson(Map<String, dynamic> jsons) {
    final service = Service()
      ..id=jsons['id']
      ..name = jsons['name']
      ..description = jsons['description']
      ..price = jsons['price']
      ..startTime = jsons['startTime']
      ..endTime = jsons['endTime']
      ..createdAt = jsons['createdAt']
      ..images= ImagesFactory.createList(json.encode(jsons['images']));
    return service;
  }
}
