import 'package:flutter/material.dart';

import '../../configs.dart';

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer({super.key, this.widget});

  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.LINEAR_GREEN_TOP,
            AppColors.FIELD_GREEN,
          ],
        ),
        // borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: widget ?? const SizedBox(),
    );
  }
}
