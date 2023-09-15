
import '../base/base.dart';

class NavigateViewModel extends BaseViewModel {
  int selectedIndex = 0;
  dynamic init() {}

  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
