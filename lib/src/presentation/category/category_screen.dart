import 'package:flutter/material.dart';

import '../../configs/configs.dart';
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ExpansionTile(
              title: Text(categories[index].name),
              children: [
                // Hiển thị nội dung danh mục ở đây
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(categories[index].name),
                        Icon(categories[index].icon),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
