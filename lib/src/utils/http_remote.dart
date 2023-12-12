import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../presentation/app/app.dart';
import '../presentation/routers.dart';
import 'utils.dart';

Client client = http.Client();
String accessToken = '';
Map<String, String> requestHeaders = {};

class Constants {
  // static String baseUrl = 'https://spa-api.dhysolutions.net/api';

  // static String baseUrl = 'https://prod.spa.dhysolutions.net/api';
   static String baseUrl = 'https://be04-2405-4802-6551-a390-7831-83ba-6457-8d1e.ngrok.io/api';

}

class HttpRemote {
  HttpRemote._();

  static final HttpRemote instance = HttpRemote._();
  static Future<void> init() async {
    accessToken = await AppPref.getToken() ?? '';
    // final fullName = await AppPref.getDataUSer('fullName') ?? '';
    // final id = await AppPref.getDataUSer('id') ?? '';
    // final email = await AppPref.getDataUSer('email') ?? '';
    // final gender = await AppPref.getDataUSer('gender') ?? '';
    // final phoneNumber = await AppPref.getDataUSer('phoneNumber') ?? '';

    // log('accessToken: $accessToken');
    // log('fullName: $fullName');
    // log('id: $id');
    // log('email: $email');
    // log('gender: $gender');
    // log('phoneNumber: $phoneNumber');

    if (accessToken.isEmpty || accessToken == 'null') {
      requestHeaders = {
        'Content-Type': 'application/json',
      };
    } else {
      requestHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
    }
  }

  static Future<void> goToLogin() async {
    await navigatorKey.currentState?.pushReplacementNamed(Routers.signIn);
  }

  static Future<void> logOut(int statusCode) async {
    if (statusCode == 401) {
      await AppPref.logout();
      await goToLogin();
    }
  }

  static Future<Response?> get({
    required String url,
    Object? body,
  }) {
    return client.get(
      Uri.parse(Constants.baseUrl + url),
      headers: requestHeaders,
    );
  }

  static Future<Response?> post({
    required String url,
    Object? body,
  }) {
    return client.post(
      Uri.parse(Constants.baseUrl + url),
      headers: requestHeaders,
      body: jsonEncode(body),
    );
  }

  static Future<Response?> put({
    required String url,
    Object? body,
  }) {
    return client.put(
      Uri.parse(Constants.baseUrl + url),
      headers: requestHeaders,
      body: body == null ? null : jsonEncode(body),
    );
  }

  static Future<Response?> delete({
    required String url,
    Object? body,
  }) {
    return client.delete(
      Uri.parse(Constants.baseUrl + url),
      headers: requestHeaders,
      body: body == null ? null : jsonEncode(body),
    );
  }

  static Future<Response?> patch({
    required String url,
    Object? body,
  }) {
    return client.patch(
      Uri.parse(Constants.baseUrl + url),
      headers: requestHeaders,
      body: jsonEncode(body),
    );
  }
}
