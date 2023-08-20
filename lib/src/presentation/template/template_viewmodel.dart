import 'package:flutter/material.dart';

import '../base/base.dart';

class TemplateViewModel extends BaseViewModel {
  final TextEditingController _fullNameController = TextEditingController();
  dynamic init() {}

  final String _errorMail = '';

  String get errorMail => _errorMail;

  final bool _isEmail = true;

  bool get isEmail => _isEmail;

  final String _errorPass = '';

  String get errorPassword => _errorPass;

  final bool _isPassword = true;

  bool get isPassword => _isPassword;

  final bool _isFullName = true;

  bool get isFullName => _isFullName;

  final String _errorFullName = '';

  String get errorFullName => _errorFullName;

  void checkPassword(String pass) {
    notifyListeners();
  }

  void checkEmail(String email) {
    notifyListeners();
  }

  void checkFullName(String fullName) {
    notifyListeners();
  }
}
