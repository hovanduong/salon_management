// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/my_category_model.dart';
import 'auth.dart';

class CategoryApi{
  Future<Result<List<CategoryModel>, Exception>> getCategory(int page) async {
    try {
      final response = await HttpRemote.get(
        url: '/category?pageSize=10&page=$page',
      );
      print(response?.statusCode);
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['items']);
          final listCategory = CategoryModelFactory.createList(data);
          return Success(listCategory);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> deleteCategory(int id) async {
    try {
      final response = await HttpRemote.delete(
        url: '/category/$id',
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

  Future<Result<bool, Exception>> putCategory(AuthParams? params) async {
    try {
      final response = await HttpRemote.put(
          url: '/category/${params!.id}', body: {'name': params.name},);
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

  Future<Result<bool, Exception>> postCategory(String? name) async {
    try {
      final response =
          await HttpRemote.post(url: '/category', body: {'name': name});
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