import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class BuildAvatar extends StatelessWidget {
  const BuildAvatar({super.key,
    this.avatar=AppImages.pngAvatar,});

  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: SizeToPadding.sizeSmall),
      child: ClipOval(
        child: Image.asset(
          avatar,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
