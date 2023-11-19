// ignore_for_file: join_return_with_assignment, avoid_positional_boolean_parameters

import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const String accessToken = 'accessToken';
  static const String deviceToken = 'deviceToken';
}

final class AppPref {
  static Future<String?>? getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(Constants.accessToken);
  }

  static Future<bool> setToken(String value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(Constants.accessToken, value);
  }

  static Future<bool> setShowCase(String name, bool value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setBool(name, value);
  }

  static Future<bool?> getShowCase(String name) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(name);
  }

  static Future<bool> setDataUser(String nameSave, String value,) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(nameSave, value);
  }

  static Future<String?>? getDataUSer(String nameSave) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(nameSave);
  }

  static Future<bool> deleteToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.remove(Constants.accessToken);
  }

  static Future<String?>? getDeviceToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(Constants.accessToken);
  }

  static Future<bool> setDeviceToken(String value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(Constants.accessToken, value);
  }

  static Future<bool> logout() async {
    final logout = await SharedPreferences.getInstance();
    return logout.clear();
  }
}
