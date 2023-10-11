class MapLocalTimeZone {
  static String mapLocalTimeZoneToSpecificTimeZone(String localTimeZone) {
    if (localTimeZone == '+07') {
      return 'Asia/Ho_Chi_Minh';
    } else {
      return 'DefaultTimeZone';
    }
  }
}
