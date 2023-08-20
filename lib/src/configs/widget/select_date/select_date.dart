import 'package:flutter/cupertino.dart';

class SelectDropDown extends StatelessWidget {
  const SelectDropDown({
    super.key,
    this.picker,
    this.height,
    this.onTap,
  });
  final Widget? picker;
  final double? height;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 300,
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22,
        ),
        child: GestureDetector(
          onTap: () => onTap!(),
          child: SafeArea(
            top: false,
            child: picker!,
          ),
        ),
      ),
    );
  }
}
