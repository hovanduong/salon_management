// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';

class CustomCornerClipPath extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    final path_0 = Path();
    path_0.moveTo(size.width*0.0025000,size.height*-0.0028571);
    path_0.lineTo(0,size.height*0.9957143);
    path_0.quadraticBezierTo(size.width*0.5965583,size.height*1.0010571,size.width*0.7835750,size.height*1.0009429);
    path_0.cubicTo(size.width*0.7959667,size.height*1.0040857,size.width*0.8183500,size.height*0.9685429,size.width*0.8151500,size.height*0.8975286);
    path_0.cubicTo(size.width*0.8091250,size.height*0.8273857,size.width*0.8008667,size.height*0.8182286,size.width*0.8120833,size.height*0.7176286);
    path_0.cubicTo(size.width*0.8437750,size.height*0.6156571,size.width*0.8799583,size.height*0.5814286,size.width*0.9121917,size.height*0.5835571);
    path_0.cubicTo(size.width*0.9574333,size.height*0.6002714,size.width*0.9983500,size.height*0.6043143,size.width,size.height*0.5439429);
    path_0.quadraticBezierTo(size.width,size.height*0.3835857,size.width,size.height*-0.0100000);
    path_0.lineTo(size.width*0.0025000,size.height*-0.0028571);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}