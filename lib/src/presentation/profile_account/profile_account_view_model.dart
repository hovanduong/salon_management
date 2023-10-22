import '../../resource/model/model.dart';
import '../../utils/app_pref.dart';
import '../base/base.dart';

class ProfileAccountViewModel extends BaseViewModel{

  UserModel? userModel;

  Future<void> init() async{
    await setDataUser();
  }

  Future<void> setDataUser()async{
    userModel = UserModel(
      email: await AppPref.getDataUSer('email') ?? '',
      fullName: await AppPref.getDataUSer('fullName') ?? '',
      gender: await AppPref.getDataUSer('gender') ?? '',
      id: int.parse(await AppPref.getDataUSer('id') ?? '0'),
      phoneNumber: await AppPref.getDataUSer('phoneNumber') ?? '',
    );
    notifyListeners();
  }
}
