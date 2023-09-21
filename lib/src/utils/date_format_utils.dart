import 'package:intl/intl.dart';

class AppDateUtils {
  static String splitHourDate(String time) {
    final result = time.split(' ');
    final hour = result[1].substring(0, 5);
    return '$hour ${result[0]}';
  }

  static String formatDateLocal(String time) {
    return DateTime.parse(time).toLocal().toString().split('.')[0];
  }

  static String formatTimeToHHMM(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDateTimeFromUtc(dynamic time) {
    try {
      return DateFormat('dd-MM-yyyy')
          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(time));
    } catch (e) {
      return DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
  }

  static String formatDateTimeFromHours(dynamic time) {
    try {
      return DateFormat('HH:mm')
          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(time));
    } catch (e) {
      return DateFormat('HH:mm').format(DateTime.now());
    }
  }

  static String formatDateTimeFromHoursAndDate(dynamic time) {
    try {
      return DateFormat('HH:mm dd-MM-yyyy')
          .format(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(time));
    } catch (e) {
      return DateFormat('HH:mm dd-MM-yyyy').format(DateTime.now());
    }
  }
}

