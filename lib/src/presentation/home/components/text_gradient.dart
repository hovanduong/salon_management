import 'package:flutter/material.dart';

import '../../../configs/constants/app_space.dart';
import '../../../configs/constants/constants.dart';

class GradientTextWidget extends StatelessWidget {
  const GradientTextWidget({super.key, 
    this.content,});
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Text(
      content??'',
      style: TextStyle(
        fontSize: SpaceBox.sizeBig,
        fontWeight: FontWeight.bold,
        foreground: Paint()..shader = const LinearGradient(
          colors: [AppColors.PRIMARY_PINK, AppColors.SECONDARY_PINK],
        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
      ),
    );
  }
}