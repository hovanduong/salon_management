// ignore_for_file: do_not_use_environment

class EnvironmentConfig {
  static const appName = String.fromEnvironment(
    'DART_DEFINES_APP_NAME',
    defaultValue: 'ApCare',
  );
  static const appSuffix = String.fromEnvironment('DART_DEFINES_APP_SUFFIX');
  static const baseUrl = String.fromEnvironment(
    'DART_DEFINES_BASE_URL',
    defaultValue: 'https://prod.spa.dhysolutions.net/api',
  );
}
