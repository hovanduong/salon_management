// ignore_for_file: unnecessary_lambdas
import 'dart:convert';

import 'my_service_model.dart';

class CategoryModel {
  bool isIconCategory;
  int? id;
  String? name;
  int? userId;
  String? deletedAt;
  String? createdAt;
  List<MyServiceModel>? myServices;
  bool? income;

  CategoryModel({
    this.isIconCategory = true,
    this.id,
    this.name,
    this.userId,
    this.deletedAt,
    this.createdAt,
    this.myServices,
    this.income,
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
    //  data['myService'] = categoryModel.myService != null
    //     ? jsonDecode(MyServiceFactory.toJson(categoryModel.myService!))
    //     : null;
    return data;
  }

  static CategoryModel _fromJson(Map<String, dynamic> json) {
    final category = CategoryModel()
      ..id = json['id']
      ..name = json['name']
      ..userId = json['userId']
      ..income = json['income']
      // ..myServices = json['myServices'] != null
      //     ? MyServiceFactory.createList(jsonEncode(json['myServices']))
      //     : null
      ..deletedAt = json['deletedAt']
      ..createdAt = json['createdAt'];
    return category;
  }
}
