import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'utils.dart';

Client client = http.Client();
String accessToken = '';
Map<String, String> requestHeaders = {};

class Constants {
  static String baseUrl = 'https://spa-api.dhysolutions.net';
}

class HttpRemote {
  HttpRemote._();

  static final HttpRemote instance = HttpRemote._();
  static Future<void> init() async {
    accessToken = await AppPref.getToken() ?? '';
    debugPrint('accessToken: $accessToken');
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
      body: jsonEncode(body),
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
