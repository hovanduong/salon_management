import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../configs/configs.dart';
import '../presentation/app/app.dart';
import '../presentation/routers.dart';
import 'utils.dart';

Client client = http.Client();
String accessToken = '';
Map<String, String> requestHeaders = {};
const baseUrl = EnvironmentConfig.baseUrl;

class HttpRemote {
  HttpRemote._();

  static final HttpRemote instance = HttpRemote._();

  static Future<void> init() async {
    accessToken = await AppPref.getToken() ?? '';
    print('accessToken: $accessToken');
    

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
      Uri.parse(baseUrl + url),
      headers: requestHeaders,
    );
  }

  static Future<Response?> post({
    required String url,
    Object? body,
  }) {
    return client.post(
      Uri.parse(baseUrl + url),
      headers: requestHeaders,
      body: jsonEncode(body),
    );
  }

  static Future<Response?> put({
    required String url,
    Object? body,
  }) {
    return client.put(
      Uri.parse(baseUrl + url),
      headers: requestHeaders,
      body: body == null ? null : jsonEncode(body),
    );
  }

  static Future<Response?> delete({
    required String url,
    Object? body,
  }) {
    return client.delete(
      Uri.parse(baseUrl + url),
      headers: requestHeaders,
      body: body == null ? null : jsonEncode(body),
    );
  }

  static Future<Response?> patch({
    required String url,
    Object? body,
  }) {
    return client.patch(
      Uri.parse(baseUrl + url),
      headers: requestHeaders,
      body: jsonEncode(body),
    );
  }
}
