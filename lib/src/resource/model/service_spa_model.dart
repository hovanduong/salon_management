import '../../configs/configs.dart';
import '../../configs/language/category_language.dart';

class ServiceSpaModel {
  ServiceSpaModel({
    this.image, 
    this.name, 
  });
  final String? image;
  final String? name;

  static List<ServiceSpaModel> listCategory=[
    ServiceSpaModel(
      name: CategoryLanguage.antiAging,
      image: AppImages.icAntiAging,
    ),
    ServiceSpaModel(
      name: CategoryLanguage.skinTreatment,
      image: AppImages.icSkinTreatment,
    ),
    ServiceSpaModel(
      name: CategoryLanguage.nailCare,
      image: AppImages.icNailCare,
    ),
    ServiceSpaModel(
      name: CategoryLanguage.bodyMassage,
      image: AppImages.icBodyMassage,
    ),
    ServiceSpaModel(
      name: CategoryLanguage.lipSpray,
      image: AppImages.icLipSpray,
    ),
    ServiceSpaModel(
      name: CategoryLanguage.facelift,
      image: AppImages.icFacelift,
    ),
    ServiceSpaModel(
      name: CategoryLanguage.footMassage,
      image: AppImages.icFootMassager,
    ),
    ServiceSpaModel(
      name: CategoryLanguage.nailArt,
      image: AppImages.icNailArt,
    ),
    ServiceSpaModel(
      name: CategoryLanguage.more,
      image: AppImages.icMore,
    ),
  ];
}
