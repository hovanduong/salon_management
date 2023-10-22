// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';

import '../../configs.dart';

class CustomBackGround extends StatelessWidget {
  const CustomBackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomClipPath(),
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 3,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.FIELD_GREEN,
              AppColors.PRIMARY_GREEN,
            ],
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  @override
  Path getClip(Size size) {
    final roundingHeight = size.height * 3 / 30;
    final filledRectangle =
        Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);
    final roundingRectangle = Rect.fromLTRB(
      0,
      size.height - roundingHeight * 2,
      size.width,
      size.height,
    );

    final path = Path();
    path.addRect(filledRectangle);
    path.arcTo(roundingRectangle, 50, 10, true);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
