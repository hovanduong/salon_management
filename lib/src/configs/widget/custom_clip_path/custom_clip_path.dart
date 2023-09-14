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
        height: MediaQuery.of(context).size.height/3,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.FIELD_GREEN,
              AppColors.PRIMARY_GREEN
            ]
          )
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final h= size.height;
    final w= size.width;
    final path = Path();
    path..lineTo(0 , h)
    ..quadraticBezierTo(w*0.5, h-50, w, h);
    path.lineTo(w, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}