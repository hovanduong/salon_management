import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configs.dart';

class LoadingDialog {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: const CupertinoActivityIndicator(
                radius: 10,
                color: AppColors.COLOR_WHITE,
              ),
            ),);
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}
