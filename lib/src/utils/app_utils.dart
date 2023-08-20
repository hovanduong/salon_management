import 'package:intl/intl.dart';

class AppUtils {
  AppUtils._();

  static String pathMediaToUrl(String? url) {
    if (url == null || url.startsWith('http')) return url ?? '';
    return "${"AppEndpoint.BASE_UPLOAD_URL"}$url";
  }

  static String convertDateTime2String(DateTime? dateTime,
      {String format = 'yy-MM-dd',}) {
    if (dateTime == null) return '';
    return DateFormat(format).format(dateTime);
  }

  static DateTime? convertString2DateTime(String? dateTime,
      {String format = 'yyyy-MM-ddTHH:mm:ss.SSSZ',}) {
    if (dateTime == null) return null;
    return DateFormat(format).parse(dateTime);
  }

  static String convertString2String(String? dateTime,
      {String inputFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ',
      String outputFormat = 'yyyy-MM-dd',}) {
    if (dateTime == null) return '';
    final input = convertString2DateTime(dateTime, format: inputFormat);
    return convertDateTime2String(input, format: outputFormat);
  }

  static String minimum(int? value) {
    if (value == null) return '00';
    return value < 10 ? '0$value' : '$value';
  }

  static String convertPhoneNumber(String phone, {String code = '+84'}) {
    return '$code${phone.substring(1)}';
  }
}
