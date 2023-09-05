// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../presentation/routers.dart';
import '../../utils/http_remote.dart';
import '../model/user_model.dart';
import 'service.dart';

class AuthParams {
  const AuthParams({
    this.user,
    this.birthDate,
    this.firstName,
    this.lastName,
    this.middleName,
    this.password,
    this.phoneNumber,
  });
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? birthDate;
  final String? phoneNumber;
  final String? password;
  final UserModel? user;
}

class AuthApi {
  Future<Result<Service, Exception>> detailsService({String? id}) async {
    try {
      final response = await HttpRemote.get(
        url: '/api/my-service/$id',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']);
          final serviceDetails = ServiceFactory.create(data);
          return Success(serviceDetails);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<Service>, Exception>> getService() async {
    try {
      final response = await HttpRemote.get(
        url: '/api/my-service',
      );
      switch (response?.statusCode) {
        case 200:
          final jsonMap = json.decode(response!.body);
          final data = json.encode(jsonMap['data']['rows']);
          final service = ServiceFactory.createList(data);
          return Success(service);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> sendOTP(
    AuthParams? params,
    BuildContext context,
  ) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final auth = FirebaseAuth.instance;
        await auth.verifyPhoneNumber(
          phoneNumber: '+84 ${params!.user!.phone}',
          verificationCompleted: (credential) {},
          verificationFailed: (e) {
            LoadingDialog.hideLoadingDialog(context);
          },
          codeSent: (verificationId, resendToken) {
            LoadingDialog.hideLoadingDialog(context);
            Navigator.pushNamed(
              context,
              Routers.verification,
              arguments: RegisterArguments(
                pass: params.password,
                verificationId: verificationId,
                userModel: params.user,
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {},
          timeout: const Duration(seconds: 60),
        );
      }
      return const Success(true);
    } on SocketException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> checkPhoneNumberExists(
    AuthParams? params,
  ) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final data = await FirebaseFirestore.instance
            .collection('phone')
            .where('phone', isEqualTo: params!.phoneNumber)
            .get();
        final phone = data.docs.map((e) => e.data());
        if (phone.isNotEmpty) {
          return Failure(Exception(phone));
        } else {
          return const Success(true);
        }
      }
      return Failure(Exception('no phone'));
    } on SocketException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<UserModel, Exception>> profile() async {
    try {
      final response = await HttpRemote.get(
        url: '/auth/profile',
      );
      switch (response?.statusCode) {
        case 200:
          final data = json.encode(json.decode(response!.body)['data']);
          final user = UserModelFactory.create(data);
          return Success(user);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> signUp(AuthParams? params) async {
    try {
      final response = await HttpRemote.post(
        url: '/api/auth/register',
        body: {
          'firstName': params!.user!.firstName,
          'lastName': params.user!.lastName,
          'middleName': '',
          'phone': params.user!.phone,
          'password': params.password
        },
      );
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

  Future<Result<String, Exception>> login(AuthParams? params) async {
    try {
      final response = await HttpRemote.post(
        url: '/api/auth/login',
        body: {
          'phoneNumber': params!.phoneNumber,
          'password': params.password,
        },
      );
      switch (response?.statusCode) {
        case 201:
          final jsonMap = json.decode(response!.body);
          final accessToken = jsonMap['data']['accessToken'];
          return Success(accessToken);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
