import '../intl/generated/l10n.dart';
import 'date_format_utils.dart';

class AppCheckTime {
  static String checkTimeNotification(String date) {
    final dateNow = DateTime.now();
    final dateLocal = DateTime.parse(date).toLocal().toString();
    final dateCreate = DateTime.parse(
      AppDateUtils.formatDateTimeNotify(AppDateUtils.formatDateTT(dateLocal)),
    );
    final inMinutes = dateNow.difference(dateCreate).inMinutes;
    final inHours = dateNow.difference(dateCreate).inHours;
    final inDays = dateNow.difference(dateCreate).inDays;
    if (inMinutes == 0) {
      return S.current.justNow;
    } else if (inMinutes > 0 && inMinutes < 60) {
      return S.current.minuteAgo(inMinutes);
    } else if (inHours > 0 && inHours < 24) {
      return S.current.hourAgo(inHours);
    } else if (inDays > 0 && inDays < 6) {
      return S.current.daysAgo(inDays);
    }
    return AppDateUtils.splitHourDate(
      AppDateUtils.formatDateLocal(
        date,
      ),
    );
  }
}
