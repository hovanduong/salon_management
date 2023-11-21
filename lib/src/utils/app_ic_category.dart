import '../configs/configs.dart';

class AppIcCategory{
  static String getIcCategory(int? idIc) {
    switch (idIc) {
      case 1:
        return AppImages.icNailCare;
      case 2:
        return AppImages.icBodyMassage;
      case 3:
        return AppImages.tattoo;
      case 4:
        return AppImages.makeUp;
      case 5:
        return AppImages.icSkinTreatment;
      case 6:
        return AppImages.makeHair;
      case 7:
        return AppImages.eyelash;
      case 8:
        return AppImages.expenses;
      case 9:
        return AppImages.eat;
      case 10:
        return AppImages.icFootMassager;
      case 11: 
        return AppImages.icAntiAging;
      case 12:
        return AppImages.icFacelift;
      case 13:
        return AppImages.icLipSpray;
      case 14:
        return AppImages.icNailArt;
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
