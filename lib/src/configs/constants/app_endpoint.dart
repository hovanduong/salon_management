// ignore_for_file: constant_identifier_names


class AppEndpoint {
  AppEndpoint._();

  // static const String BASE_APP_ENDPOINT = "https://ame.chuctet.online/api";
  static const String BASE_APP_ENDPOINT = 'https://nhaxemanhcuong.com/api';

  static const int connectionTimeout = 100000;
  static const int receiveTimeout = 100000;
  static const String keyAuthorization = 'Authorization';

  static const int SUCCESS = 200;
  static const int ERROR_TOKEN = 401;
  static const int ERROR_VALIDATE = 422;
  static const int ERROR_SERVER = 500;
  static const int ERROR_DISCONNECT = -1;
}
