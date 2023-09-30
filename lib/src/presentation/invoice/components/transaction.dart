import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key, 
    this.name, 
    this.subtile, 
    this.money,
  });

  final String? name;
  final String? subtile;
  final String? money;

  @override
  Widget build(BuildContext context) {
    var isColor = '+';
    if(money!=null){
      isColor= money!.split(' ')[0];
    }
    return ListTile(
      leading: CircleAvatar( 
        backgroundColor: AppColors.PRIMARY_GREEN,
        child: Paragraph(
          content: name!.split('')[0].toUpperCase(),
          style: STYLE_BIG.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.COLOR_WHITE
          ),
        ),
      ),
      title: Paragraph(
        content: name ?? '',
        style: STYLE_LARGE_BOLD.copyWith(
          color: AppColors.BLACK_500,
        ),
      ),
      subtitle: Paragraph(
        content: subtile ?? '',
        style: STYLE_MEDIUM.copyWith(
          color: AppColors.COLOR_GREY,
        ),
      ),
      trailing: Paragraph(
        content: money ?? '',
        style: STYLE_LARGE_BOLD.copyWith(
          color: isColor == '+' 
            ?AppColors.FIELD_GREEN 
            :AppColors.PRIMARY_RED,
        ),
      ),
    );
  }
}