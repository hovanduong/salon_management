// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import '../../configs/app_exception/app_exception.dart';
import '../../configs/configs.dart';
import '../../utils/http_remote.dart';
import '../model/auth_model.dart';
import '../model/model.dart';

class AuthParams {
  const AuthParams({
    this.userModel,
    this.phoneNumber,
    this.password,
    this.fullName,
    this.gender,
    this.email,
    this.passwordConfirm,
    this.oldPass,
  });
  final UserModel? userModel;
  final String? phoneNumber;
  final String? password;
  final String? oldPass;
  final String? fullName;
  final String? gender;
  final String? email;
  final String? passwordConfirm;
}

class AuthApi {
  Future<Result<bool, AppException>> signUp(AuthParams? params) async {
    try {
      final response = await HttpRemote.post(
        url: '/auth/register',
        body: {
          'phoneNumber': params!.phoneNumber,
          'fullName': params.fullName,
          'gender': params.gender,
          'email': params.email,
          'password': params.password,
          'passwordConfirm': params.passwordConfirm,
        },
      );
      switch (response?.statusCode) {
        case 201:
          return const Success(true);
        case 400:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['code']);
          return Failure(AppException(data));
        default:
          return Failure(AppException(response!.reasonPhrase!));
      }
    } on AppException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<AuthModel, Exception>> login(AuthParams? params) async {
    try {
      final response = await HttpRemote.post(
        url: '/auth/login',
        body: {
          'phoneNumber': params!.phoneNumber,
          'password': params.password,
        },
      );
      switch (response?.statusCode) {
        case 201:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']);
          final userData = AuthModelFactory.create(data);
          return Success(userData);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> deleteAccount() async {
    try {
      final response = await HttpRemote.delete(
        url: '/auth/remove-account',
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

  Future<Result<bool, AppException>> changePassword(
    AuthParams params,
  ) async {
    try {
      final response = await HttpRemote.put(
        url: '/auth/change-pass',
        body: {
          'oldPassword': params.oldPass,
          'newPassword': params.password,
        },
      );
      switch (response?.statusCode) {
        case 200:
          return const Success(true);
        case 400:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['code']);
          return Failure(AppException(data));
        default:
          return Failure(AppException(response!.reasonPhrase!));
      }
    } on AppException catch (e) {
      return Failure(e);
    }
  }
}
