import 'dart:io';

import '../intl/generated/l10n.dart';

class AppValid {
  AppValid._();
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validEnterFullName;
    } else if (value.length < 2) {
      return S.current.validName;
    }
    final regex = RegExp(
        r'^[a-z A-ZỳọáầảấờễàạằệếýộậốũứĩõúữịỗìềểẩớặòùồợãụủíỹắẫựỉỏừỷởóéửỵẳẹèẽổẵẻỡơôưăêâđỲỌÁẦẢẤỜỄÀẠẰỆẾÝỘẬỐŨỨĨÕÚỮỊỖÌỀỂẨỚẶÒÙỒỢÃỤỦÍỸẮẪỰỈỎỪỶỞÓÉỬỴẲẸÈẼỔẴẺỠƠÔƯĂÊÂĐ]+$',);
    if (!regex.hasMatch(value)) {
      return S.current.validFullName;
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validEnterPhoneNumber;
    }
    final regex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (!regex.hasMatch(value)) {
      return S.current.validFullName;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validEnterPass;
    }
    if (value.length < 6 || value.length > 16) {
      return S.current.validPass;
    }
    return null;
  }

  static String? validatePasswordConfirm(String pass, String? confirmPass) {
    if (confirmPass == null || confirmPass.isEmpty) {
      return S.current.validEnterConfirmPass;
    }
    if (confirmPass != pass) {
      return S.current.validConfirmPass;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validEnterEmail;
    } else {
      final regex = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',);

      if (!regex.hasMatch(value)) {
        return S.current.validEmail;
      } else {
        return null;
      }
    }
  }

  static String? validateVerificationCode(String? value) {
    final regex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (value == null || value.isEmpty) {
      return S.current.emptyVerificationCode;
    } else if (value.length != 6 && !regex.hasMatch(value)) {
      return S.current.validVerificationCode;
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String? value) {
    final regex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');

    if (value == null || value.isEmpty) {
      return S.current.validEnterPhoneNumber;
    } else if (value.length != 10) {
      return S.current.validPhoneNumber;
    } else if (!regex.hasMatch(value)) {
      return S.current.validPhone;
    } else {
      return null;
    }
  }

  static bool isNetWork(dynamic value) {
    if (value is SocketException) {
      return false;
    }
    return true;
  }
}
