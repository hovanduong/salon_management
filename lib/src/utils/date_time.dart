import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getDay(String dateTime) => dateTime.substring(0, 2);
  static String getMonth(String dateTime) => dateTime.substring(3, 5);
  static String getNameOfWeek(String dateTime, String dateFormat) =>
      DateFormat('EEEE').format(DateFormat(dateFormat).parse(dateTime));
  static String getHHmm(String dateTime) => dateTime.substring(11, 16);
}
