import 'package:flutter/material.dart';

import '../../configs.dart';

dynamic showDialogNetwork(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return WarningOneDialog(
        content: ChangePasswordLanguage.errorNetwork,
        image: AppImages.icPlus,
        title: SignUpLanguage.failed,
        buttonName: SignUpLanguage.cancel,
        color: AppColors.BLACK_500,
        colorNameLeft: AppColors.BLACK_500,
        onTap: () => Navigator.pop(context),
      );
    },
  );
}
