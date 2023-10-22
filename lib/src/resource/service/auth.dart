// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

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
  });
  final UserModel? userModel;
  final String? phoneNumber;
  final String? password;
  final String? fullName;
  final String? gender;
  final String? email;
  final String? passwordConfirm;
}

class AuthApi {
  Future<Result<bool, Exception>> signUp(AuthParams? params) async {
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
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
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
          final userData= AuthModelFactory.create(data);
          return Success(userData);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
