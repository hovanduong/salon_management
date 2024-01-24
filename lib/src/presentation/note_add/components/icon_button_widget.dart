import 'package:flutter/material.dart';

import '../../../configs/configs.dart';

class ButtonIconWidget extends StatelessWidget {
  const ButtonIconWidget({
    Key? key, 
    this.icon,
    this.onTap, 
    this.text,
    this.isEnableButton=true,
  })
    : super(key: key);

  final IconData? icon;
  final Function()? onTap;
  final String? text;
  final bool isEnableButton;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: icon != null ? 50 : 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isEnableButton? AppColors.PRIMARY_GREEN
          : AppColors.BLACK_300,
        ),
        child: Center(
          child: icon!=null? Icon(icon, color: Colors.white)
            : Text(
                text??'',
                style: STYLE_MEDIUM.copyWith(
                  color: AppColors.COLOR_WHITE,
                ),
              ),
        ),
      ),
    );
  }
}
