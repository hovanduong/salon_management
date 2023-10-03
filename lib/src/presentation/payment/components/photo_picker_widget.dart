import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class PhotoPickerWidget extends StatefulWidget {
  const PhotoPickerWidget({
    this.decorationImage,
    this.icon,
    super.key,
  });

  final DecorationImage? decorationImage;
  final Icon? icon;
  @override
  State<PhotoPickerWidget> createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      dashPattern: const [6, 6],
      padding: const EdgeInsets.all(6),
      color: AppColors.PRIMARY_PINK,
      child: Container(
      height: 135,
      width: 90,
      decoration: BoxDecoration(
       
        borderRadius: BorderRadius.circular(10),
        image: widget.decorationImage,
      ),
      child: widget.icon,
    ),
      );
    
    // Container(
    //   height: 135,
    //   width: 95,
    //   decoration: BoxDecoration(
    //     border: Border.all(
    //       color: AppColors.PRIMARY_PINK,
    //     ),
    //     borderRadius: BorderRadius.circular(10),
    //     image: widget.decorationImage,
    //   ),
    //   child: widget.icon,
    // );
  }
}
