import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'category_viewmodel.dart';

class Category {
  final String name;
  final IconData icon;

  Category(this.name, this.icon);
}

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<CategoryViewModel>(
      viewModel: CategoryViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) {
        return buildCategory();
      },
    );
  }

  final List<Category> categories = [
    Category('ID', Icons.add),
    Category('Name', Icons.add),
  ];

  Widget buildCategory() {
    return Scaffold(
      appBar: AppBar(
        title: Paragraph(
          content: 'Category',
          style: STYLE_LARGE_BOLD.copyWith(),
        ),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return buildContentCategoryWidget(categories, index);
        },
      ),
    );
  }
}

Widget buildContentCategoryWidget(List<Category> categories, int index) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeVerySmall),
    child: ExpansionTile(
      title: Text(categories[index].name),
      children: [
        Padding(
          padding: EdgeInsets.all(SizeToPadding.sizeSmall),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, service5Index) {
              return ListTile(
                title: Text(categories[index].name),
              );
            },
          ),
        ),
      ],
    ),
  );
}
