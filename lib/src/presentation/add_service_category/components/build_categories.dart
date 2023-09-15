import 'package:flutter/material.dart';

import '../../../configs/configs.dart';
import '../../../configs/constants/app_space.dart';

class BuildListCategories extends StatefulWidget {
  const BuildListCategories({super.key, this.category, this.selectedCategory});

  final List? category;
  final List? selectedCategory;

  @override
  State<BuildListCategories> createState() => _BuildListCategoriesState();
}

class _BuildListCategoriesState extends State<BuildListCategories> {
  List<bool> isCheck = [];

  Widget buildCategories(int index) {
    return CheckboxListTile(
      value: isCheck[index],
      onChanged: (value) {
        isCheck[index] = value!;
        setState(() {});
      },
      activeColor: AppColors.PRIMARY_GREEN,
      title: Paragraph(
        content: widget.category?[index] ?? '',
      ),
    );
  }

  Widget buildButton() {
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeBig),
      child: AppButton(
        enableButton: true,
        content: UpdateProfileLanguage.submit,
        onTap: () {
          widget.selectedCategory?.clear();
          for (var i = 0; i < isCheck.length; i++) {
            if (isCheck[i] == true) {
              widget.selectedCategory!.add(widget.category![i]);
            }
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < widget.category!.length; i++) {
      isCheck.add(false);
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.category!.isEmpty ? 0 : widget.category!.length,
            itemBuilder: (context, index) => buildCategories(index),
          ),
        ),
        buildButton(),
      ],
    );
  }
}
