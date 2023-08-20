// ignore_for_file: do_not_use_environment

class EnvironmentConfig {
  static const appName = String.fromEnvironment(
    'DART_DEFINES_APP_NAME',
    defaultValue: 'QLTVX',
  );
  static const appSuffix = String.fromEnvironment('DART_DEFINES_APP_SUFFIX');
  static const baseUrl = String.fromEnvironment(
    'DART_DEFINES_BASE_URL',
    defaultValue: 'https://ame.chuctet.online/api',
  );
}
