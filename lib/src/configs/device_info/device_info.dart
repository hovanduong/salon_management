import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  String? id;
  String? name;
  String? version;
  String? os;
  DeviceInfo({this.id, this.version, this.name, this.os});
}

class AppDeviceInfo {
  AppDeviceInfo._();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static DeviceInfo? _deviceInfo;

  static String? get deviceID => _deviceInfo?.id;

  static String? get deviceName => _deviceInfo?.name;

  static String? get deviceVersion => _deviceInfo?.version;
  static String? get os => _deviceInfo?.os;

  static Future init() async {
    _deviceInfo = await getDeviceDetails();
    print('AppDeviceInfo: $deviceID - $deviceName - $deviceVersion - $os');
  }

  static Future<DeviceInfo?> getDeviceDetails() async {
    DeviceInfo? device;
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfoPlugin.androidInfo;
        device = DeviceInfo(
          name: info.model,
          version: info.version.codename,
          id: info.id,
          os: 'Android',
        );
      } else if (Platform.isIOS) {
        final info = await _deviceInfoPlugin.iosInfo;
        device = DeviceInfo(
          name: info.name,
          version: info.systemVersion,
          id: info.identifierForVendor,
          os: 'IOS',
        );
      }
    } catch (e) {
      print('Failed to get platform version: $e');
    }
    return device;
  }
}
