import '../../configs/app_result/app_result.dart';
import '../../resource/model/my_booking_model.dart';
import '../../resource/service/my_booking.dart';
import '../../utils/app_valid.dart';
import '../base/base.dart';

class BookingDetailsViewModel extends BaseViewModel{
  bool isLoading=true;
  MyBookingApi myBookingApi = MyBookingApi();
   List<MyBookingModel> listMyBooking = [];

  Future<void> init(String id)async{
    await getMyBookingUser(id);
    isLoading=false;
    notifyListeners();
  }

  Future<void> getMyBookingUser(String id) async {
    final result = await myBookingApi.getMyBookingUser(id);

    final value = switch (result) {
      Success(value: final listMyBooking) => listMyBooking,
      Failure(exception: final exception) => exception,
    };

    if (!AppValid.isNetWork(value)) {
      // showDialogNetwork(context);
    } else if (value is Exception) {
      // showErrorDialog(context);
    } else {
      listMyBooking = value as List<MyBookingModel>;
    }
    notifyListeners();
  }
}
