// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/check_time.dart';
import '../../configs.dart';
import '../../constants/app_space.dart';
import '../../language/notification_language.dart';

class NotificationUpdate extends StatelessWidget {
  const NotificationUpdate({
    super.key, 
    this.color, 
    this.date,
  });

  final Color? color;
  final String? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVeryVerySmall,
        horizontal: SizeToPadding.sizeSmall,
      ),
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        borderRadius: BorderRadius.circular(SpaceBox.sizeSmall),
        boxShadow: [
          BoxShadow(
            color: AppColors.BLACK_300,
            blurRadius: SpaceBox.sizeVerySmall,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleNotification(),
          const Divider( color: AppColors.BLACK_200,),
          messageNotification(),
          SizedBox(height: SizeToPadding.sizeVerySmall,),
          buildFooterNotification(),
        ],
      ),
    );
  }

  Widget buildFooterNotification(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(content: AppCheckTime.checkTimeNotification(
          date??'',
        ), 
          color: color?? AppColors.PRIMARY_GREEN,),
        Row(
          children: [
            Paragraph(
              content: NotificationLanguage.details,
              fontWeight: FontWeight.w400,
              color: color?? AppColors.PRIMARY_GREEN,
            ),
            Icon(Icons.arrow_forward_ios_outlined, 
              color: color?? AppColors.PRIMARY_GREEN, size: 10,
            )
          ],
        ),
      ],
    );
  }

  Widget buildTitleNotification(){
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeVerySmall),
      child: Row(
        children: [
          SvgPicture.asset(AppImages.icStar, 
            color: color),
          SizedBox(width: SizeToPadding.sizeVerySmall,),
          Paragraph(
            content: NotificationLanguage.newFeature,
            style: STYLE_MEDIUM.copyWith(
              fontWeight: FontWeight.w600,
              color: color?? AppColors.BLACK_500,
            ),
          ),
        ],
      ),
    );
  }

  Widget messageNotification(){
    return RichText(
      text: TextSpan(
        style: STYLE_MEDIUM.copyWith(
          color: color??AppColors.BLACK_500,
        ),
        children: [
          const TextSpan(
            text: 'Tinh năng mới vừa ra mắt trên Ứng dụng ',
          ),
          TextSpan(
            text: 'ApCare. Cập nhật lại ứng dụng',
            style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
          ),
          const TextSpan(
            text: ' trên App Store hoặc CH Play để trải nghiệm ngay!',
          ),
        ],
      ),
    );
  }
}
