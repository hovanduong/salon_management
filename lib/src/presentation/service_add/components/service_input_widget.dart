import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class ServiceInputWidget extends StatefulWidget {
  const ServiceInputWidget({
    this.hintText,
    this.labelText,
    this.validator,
    this.textEditingController,
    this.onChanged,
    this.obscureText = false,
    this.isSpace = false,
    this.keyboardType,
    this.suffixIcon,
    this.maxLenght,
    super.key,
  });
  final String? hintText;
  final String? labelText;
  final String? validator;
  final bool? isSpace;
  final bool obscureText;
  final TextEditingController? textEditingController;
  final Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final IconButton? suffixIcon;
  final int? maxLenght;
  @override
  State<ServiceInputWidget> createState() => _ServiceInputWidgetState();
}

class _ServiceInputWidgetState extends State<ServiceInputWidget> {
  late bool hiddenPassword;

  @override
  void initState() {
    hiddenPassword = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Paragraph(
          content: widget.labelText ?? '',
          fontWeight: FontWeight.w500,
        ),
        SizedBox(
          height: SpaceBox.sizeVerySmall,
        ),
        TextFormField(
          maxLength: widget.maxLenght,
          keyboardType: widget.keyboardType,
          controller: widget.textEditingController,
          onChanged: widget.onChanged,
          obscureText: hiddenPassword,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: SizeToPadding.sizeSmall,
              horizontal: SizeToPadding.sizeSmall,
            ),
            hintText: widget.hintText ?? '',
            hintStyle: STYLE_MEDIUM.copyWith(color: AppColors.BLACK_400),
            fillColor: AppColors.COLOR_WHITE,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
              borderSide: const BorderSide(
                color: AppColors.PRIMARY_PINK,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
              borderSide: const BorderSide(
                color: AppColors.BLACK_200,
              ),
            ),
            suffixIcon: widget.suffixIcon,
          ),
        ),
        SizedBox(
          height: SpaceBox.sizeVerySmall,
        ),
        Paragraph(
          // textAlign: TextAlign.center,
          content: widget.validator ?? '',
          fontWeight: FontWeight.w500,
          color: AppColors.PRIMARY_RED,
        ),
        if (widget.isSpace ?? false)
          SizedBox(
            height: SpaceBox.sizeSmall,
          ),
      ],
    );
  }
}
