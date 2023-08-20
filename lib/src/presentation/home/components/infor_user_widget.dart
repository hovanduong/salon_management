import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class InforUserWidget extends StatelessWidget {
  const InforUserWidget({
    super.key, 
    this.onTap, this.image, 
    this.name, this.service, 
    this.price, this.description, this.address,
  });

  final Function()? onTap;
  final String? image;
  final String? address;
  final String? name;
  final String? service;
  final String? price;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: SpaceBox.sizeMedium),
      child: InkWell(
        onTap: (){
          onTap!();
        },
        child: Stack(
          children: [
            buildImage(),
            buildAddress(),
            buildInfor(),
          ],
        ),
      ),
    );
  }

  Widget buildImage(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
      child: Image.network(
        image??'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmVfPm6hKZTky6SpTNvEZqaqa8frwh_4Y2Mj4ERoDp0ammsl4LYgjM3VJHBjITmADt8lg&usqp=CAU',
        fit: BoxFit.cover,
        width: double.maxFinite,
        height: double.maxFinite,
      ),
    );
  }

  Widget buildAddress(){
    return Positioned(
      top: SpaceBox.sizeSmall,
      right: SpaceBox.sizeSmall,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeVerySmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(132, 242, 243, 244),
        ),
        child: Paragraph(
          content: address??'',
          style: STYLE_SMALL.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildPrice(){
    return Container(
      margin: EdgeInsets.only(left: SpaceBox.sizeMedium),
      padding: EdgeInsets.symmetric(
        horizontal: SpaceBox.sizeSmall,
        vertical: 3,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.PRIMARY_PINK,
            AppColors.SECONDARY_PINK],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Paragraph(
        content: price??'',
        style: STYLE_VERY_SMALL_BOLE.copyWith(
          color: AppColors.COLOR_WHITE,
        ),
      ),
    );
  }

  Widget buildInfor(){
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeVerySmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Paragraph(
            content: name??'',
            style: STYLE_BIG.copyWith(
              color: AppColors.BLACK_500,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SpaceBox.sizeSmall,),
          Row(
            children: [
              buildService(),
              buildPrice(),
            ],
          ),
          Paragraph(
            maxLines: 2,
            content: description??'',
            style: STYLE_SMALL.copyWith(
              color: AppColors.BLACK_500,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildService(){
    return Row(
      children: [
        Paragraph(
          content: '${HomeLanguage.service}:',
          style: STYLE_SMALL.copyWith(
            color: AppColors.BLACK_500,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: SpaceBox.sizeVerySmall,),
        Paragraph(
          content: service??'',
          style: STYLE_SMALL.copyWith(
            color: AppColors.BLACK_500,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}