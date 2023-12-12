// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';

import '../../configs/app_result/app_result.dart';
import '../../utils/http_remote.dart';
import '../model/version_app_model.dart';

class VersionAppApi {
  Future<Result<int, Exception>> checkAppVersion() async {
    try {
      final response =
          await HttpRemote.get(url: '/version-app/check-version-app');
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['currentVersion']);
          return Success(int.parse(data));
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<int, Exception>> getMaxVerSion() async {
    try {
      final response = await HttpRemote.get(url: '/version-app/max-version');
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['version']);
          return Success(int.parse(data));
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> postVersionApp(
    int? version,
  ) async {
    try {
      final response = await HttpRemote.post(
        url: '/version-app',
        body: {
          'version': version ?? 0,
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
