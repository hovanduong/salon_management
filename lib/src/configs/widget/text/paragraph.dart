import 'package:flutter/widgets.dart';

import '../../constants/app_styles.dart';

class Paragraph extends StatelessWidget {
  const Paragraph({
    super.key,
    this.content,
    this.style,
    this.fontWeight,
    this.color,
    this.overflow,
    this.textAlign, 
    this.maxLines,
  });
  final String? content;
  final TextStyle? style;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      content ?? '',
      style:
          style ?? STYLE_SMALL.copyWith(fontWeight: fontWeight, color: color),

      overflow: overflow,
    );
  }
}
