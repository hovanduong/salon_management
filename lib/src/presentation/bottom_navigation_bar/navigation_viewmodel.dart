
import '../base/base.dart';

class NavigateViewModel extends BaseViewModel {
  int selectedIndex = 0;
  dynamic init(int? page) {
    if(page != null){
      selectedIndex=page;
    }
  }

  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
