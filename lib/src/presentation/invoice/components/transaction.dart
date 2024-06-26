import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class Transaction extends StatelessWidget {
  const Transaction({
    super.key,
    this.name,
    this.subtile,
    this.money,
    this.color,
  });

  final String? name;
  final String? subtile;
  final String? money;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var isColor = '+';
    final alphabet = name!=null? name?.split('')[0].toUpperCase(): null;
    if (money != null) {
      isColor = money!.split(' ')[0];
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child:alphabet!=null? Paragraph(
          content: alphabet,
          style: STYLE_BIG.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.COLOR_WHITE,),
        ): Container(),
      ),
      title: Paragraph(
        content: name ?? '',
        style: STYLE_LARGE_BOLD.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Paragraph(
        content: subtile ?? '',
        style: STYLE_MEDIUM.copyWith(
          color: AppColors.COLOR_GREY,
        ),
      ),
      trailing: Paragraph(
        content: money ?? '',
        style: STYLE_MEDIUM_BOLD.copyWith(
          color: isColor == '+' ? AppColors.Green_Money : AppColors.Red_Money,
        ),
      ),
    );
  }
}
