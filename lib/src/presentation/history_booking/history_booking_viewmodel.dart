import '../base/base.dart';

class HistoryBookingViewModel extends BaseViewModel{
  bool isSwitch=false;

  dynamic init(){}

  void setIsSwitch(){
    isSwitch= !isSwitch;
    notifyListeners();
  }
}