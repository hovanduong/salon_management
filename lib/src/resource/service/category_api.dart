// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/my_category_model.dart';

class CategoryParams {
  const CategoryParams({
    this.id,
    this.name,
    this.income=true,
    this.imageId,
    this.isUser,
    this.page,
  });
  final int? id;
  final int? isUser;
  final String? name;
  final bool income;
  final int? imageId;
  final int? page;
}

class CategoryApi {
  Future<Result<List<CategoryModel>, Exception>> getListCategory(
    CategoryParams? params,
  ) async {
    try {
      final response = await HttpRemote.get(
        url: params!=null?
         '/category?pageSize=20&page=${params.page}&isUser=${params.isUser}'
         : '/category',
      );
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

  Future<Result<bool, Exception>> putCategory(CategoryParams? params) async {
    try {
      final response = await HttpRemote.put(
        url: '/category/${params!.id}',
        body: {
          'name': params.name,
          'income': params.income,
          'imageId': params.imageId,
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

  Future<Result<bool, Exception>> postCategory(CategoryParams? params) async {
    try {
      final response = await HttpRemote.post(
        url: '/category', 
        body: {
          'name': params!.name,
          'income': params.income,
          'imageId': params.imageId,
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
}
