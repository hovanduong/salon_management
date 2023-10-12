import 'package:intl/intl.dart';

class AppCheckDate {
  static final dateNow= DateTime.now();

  static String subtractDate(String date){
    try {
      return DateFormat('yyyy-MM-dd').format(parseDate(date).subtract(
        const Duration(days: 6),),);
    } catch (e) {
      return DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
  }

  static DateTime parseDate(String time) {
    try {
      return DateFormat('dd/MM/yyyy').parse(time);
    } catch (e) {
      return DateFormat('dd/MM/yyyy').parse(DateTime.now().toString());
    }
  }

  static String formatDate(DateTime time) {
    try {
      return DateFormat('dd/MM/yyyy').format(time);
    } catch (e) {
      return DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
  }

   static String formatYMD(dynamic time) {
    try {
      return DateFormat('yyyy-MM-dd')
          .format(DateFormat('dd/MM/yyyy').parse(time));
    } catch (e) {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  static String getDateBefore(){
    return formatDate(dateNow.subtract(const Duration(days: 1)));
  }

  static String getDateOfMonth(){
    final dayStart= DateFormat('dd/MM/yyyy').format(
      DateTime(dateNow.year, dateNow.month , 1),
    );
    final dayEnd = DateFormat('dd/MM/yyyy').format(
      DateTime(dateNow.year, dateNow.month +1, 0),
    );
    return '$dayStart - $dayEnd';
  }

  static String getDateOfWeek(){
    final dayStart= dateNow.subtract(Duration(days: dateNow.weekday - 1));
    final dayEnd = DateFormat('dd/MM/yyyy').format(
      dayStart.add(const Duration(days: 6)),
    );
    return '${formatDate(dayStart)} - $dayEnd';
  }
}
