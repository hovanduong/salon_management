import '../../configs/app_result/app_result.dart';
import '../../utils/http_remote.dart';
import 'auth.dart';

class DeviceInfoParams {
  DeviceInfoParams({
    this.deviceID,
    this.deviceName,
    this.deviceVersion,
    this.os,
  });
  String? deviceID;
  String? deviceName;
  String? deviceVersion;
  String? os;
}

class DeviceInfoApi {
  Future<Result<bool, Exception>> postDeviceInfo(
    DeviceInfoParams? params,
  ) async {
    try {
      final response = await HttpRemote.post(
        url: '/auth/device-info',
        body: {
          'deviceID': params?.deviceID ?? '',
          'deviceName': params?.deviceName ?? '',
          'deviceVersion': params?.deviceVersion ?? '',
          'os': params?.os ?? '',
        },
      );
      switch (response?.statusCode) {
        case 201:
          return const Success(true);
        default:
          return Failure(Exception(response!.reasonPhrase));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
