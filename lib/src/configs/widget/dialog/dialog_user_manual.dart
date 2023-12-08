import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs.dart';
import '../../constants/app_space.dart';

class DialogUserManual extends StatelessWidget {
  const DialogUserManual({
    Key? key,
    this.title, 
    this.widget,
  }) : super(key: key);
  final String? title;
  final Widget? widget;

  dynamic dialogContent(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeToPadding.sizeMedium,
              ),
              child: Paragraph(
                textAlign: TextAlign.center,
                content: title,
                style: STYLE_BIG.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: SizeToPadding.sizeSmall,),
            widget??const SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
