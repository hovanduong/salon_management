import 'package:flutter/cupertino.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';
import '../../../utils/app_currency.dart';

class TotalMoneyWidget extends StatelessWidget {
  const TotalMoneyWidget({
    super.key, 
    this.content, 
    this.money, 
    this.colorMoney,
  });

  final String? content;
  final num? money;
  final Color? colorMoney;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Paragraph(
          content: content ?? '',
          style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: SpaceBox.sizeMedium,),
        Paragraph(
          content: AppCurrencyFormat.formatMoneyD(money ?? 0),
          textAlign: TextAlign.center,
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w600,
            color: colorMoney,
          ),
        ),
      ],
    );
  }
}
