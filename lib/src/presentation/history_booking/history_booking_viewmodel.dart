import 'package:url_launcher/url_launcher.dart';

import '../base/base.dart';

class HistoryBookingViewModel extends BaseViewModel{
  bool isSwitch=false;

  dynamic init(){}

  void setIsSwitch(){
    isSwitch= !isSwitch;
    notifyListeners();
  }

  Future<void> sendPhone(String phoneNumber, String scheme) async {
    print(phoneNumber);
    final launchUri = Uri(
      scheme: scheme,
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}