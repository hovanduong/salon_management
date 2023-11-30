import '../configs/configs.dart';

class AppIcCategory {
  static String getIcCategory(int? idIc) {
    switch (idIc) {
      case 1:
        return AppImages.icBodyMassage;
      case 2:
        return AppImages.icNailCare;
      case 3:
        return AppImages.eyelash;
      case 4:
        return AppImages.makeHair;
      case 5:
        return AppImages.icSpa;
      case 6:
        return AppImages.makeUp;
      case 7:
        return AppImages.icLipSpray;
      case 8:
        return AppImages.eat;
      case 9:
        return AppImages.icFacelift;
      case 10:
        return AppImages.icNailArt;
      case 11:
        return AppImages.icAntiAging;
      case 12:
        return AppImages.expenses;
      case 13:
        return AppImages.tattoo;
      case 14:
        return AppImages.icFootMassager;
      case 15:
        return AppImages.spaMask;
      case 16:
        return AppImages.icMore;
      case 17:
        return AppImages.icClose;
      default:
        return AppImages.icSpa;
    }
  }
}
