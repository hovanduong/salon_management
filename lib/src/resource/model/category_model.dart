// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

import 'my_servcie_model.dart';


class CategoryModel {
  int? id;
  String? name;
  int? userId;
  String? deletedAt;
  String? createdAt;
  List<MyServicceModel>? myService;

  CategoryModel({
    this.id,
    this.name,
    this.userId,
    this.deletedAt,
    this.createdAt,
    this.myService,
  });
}

abstract class CategoryModelFactory {
  static List<CategoryModel> createList(String jsonString) {
    final rawModels = jsonDecode(jsonString) as List;
    final models = rawModels
        .map((rawModel) => CategoryModelFactory._fromJson(rawModel))
        .toList();
    return models;
  }

  static CategoryModel create(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    final categoryModel = _fromJson(jsonMap);
    return categoryModel;
  }

  static String toJson(CategoryModel model) {
    final data = _toMap(model);
    return json.encode(data);
  }

  static Map<String, dynamic> _toMap(
    CategoryModel categoryModel,
  ) {
    final data = <String, dynamic>{};
    data['name'] = categoryModel.name;
    data['userId'] = categoryModel.userId;
    data['deletedAt'] = categoryModel.deletedAt;
    data['createdAt'] = categoryModel.createdAt;
    data['myService'] = categoryModel.myService;
    return data;
  }

  static CategoryModel _fromJson(Map<String, dynamic> jsons) {
    final category = CategoryModel()
      ..id=jsons['id']
      ..name = jsons['name']
      ..userId = jsons['userId']
      ..deletedAt = jsons['deletedAt']
      ..createdAt = jsons['createdAt']
      ..myService= MyServiceFactory.createList(json.encode(jsons['myServices']));
    return category;
  }
}
