import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_space.dart';
import '../../constants/app_styles.dart';
import '../text/paragraph.dart';

class AppFormField extends StatefulWidget {
  const AppFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.validator,
    this.textEditingController,
    this.onChanged,
    this.obscureText = false,
    this.isSpace = false,
    this.keyboardType,
    this.maxLenght,
    this.maxLines,
    this.counterText,
    this.onTap,
    this.enabled,
    this.iconButton,
    this.suffixText, 
    this.inputFormatters,
    this.isRequired=false
  });
  final Function()? onTap;
  final String? hintText;
  final String? labelText;
  final String? validator;
  final bool? enabled;
  final bool? isSpace;
  final String? suffixText;
  final bool obscureText;
  final TextEditingController? textEditingController;
  final Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final int? maxLenght;
  final int? maxLines;
  final String? counterText;
  final IconButton? iconButton;
  final List<TextInputFormatter>? inputFormatters;
  final bool isRequired;
  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  late bool hiddenPassword;

  @override
  void initState() {
    hiddenPassword = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Paragraph(
                content: widget.labelText ?? '',
                fontWeight: FontWeight.w600,
              ),
              if (widget.isRequired) const Paragraph(
                content: '*',
                fontWeight: FontWeight.w600,
                color: AppColors.PRIMARY_RED,
              ) else Container(),
            ],
          ),
          SizedBox(
            height: SpaceBox.sizeVerySmall,
          ),
          TextFormField(
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            maxLines: widget.maxLines ?? 1,
            maxLength: widget.maxLenght,
            keyboardType: widget.keyboardType,
            controller: widget.textEditingController,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            obscureText: hiddenPassword,
            decoration: InputDecoration(
              suffixText: widget.suffixText ?? '',
              counterText: widget.counterText,
              contentPadding: EdgeInsets.symmetric(
                vertical: SizeToPadding.sizeSmall,
                horizontal: SizeToPadding.sizeMedium,
              ),
              hintText: widget.hintText ?? '',
              hintStyle: STYLE_MEDIUM.copyWith(color: AppColors.BLACK_400),
              fillColor: AppColors.COLOR_WHITE,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
                borderSide: const BorderSide(
                  color: AppColors.FIELD_GREEN,
                  width: 2
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(BorderRadiusSize.sizeSmall),
                borderSide: const BorderSide(
                  color: AppColors.BLACK_200,
                ),
              ),
              suffixIcon: (widget.obscureText)
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          hiddenPassword = !hiddenPassword;
                        });
                      },
                      child: Icon(
                        hiddenPassword ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.BLACK_300,
                      ),
                    )
                  : null,
              prefixIcon: widget.iconButton,
            ),
          ),
          SizedBox(
            height: SpaceBox.sizeVerySmall,
          ),
          Paragraph(
            textAlign: TextAlign.center,
            content: widget.validator ?? '',
            fontWeight: FontWeight.w500,
            color: AppColors.PRIMARY_RED,
          ),
          if (widget.isSpace ?? false)
            SizedBox(
              height: SpaceBox.sizeSmall,
            ),
        ],
      ),
    );
  }
}
