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
    Category('UserID', Icons.add),
    Category('My Services', Icons.add),
    Category('Create AT', Icons.add),
    Category('Update AT', Icons.add),
    Category('Delete AT', Icons.add),
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
            child: ListTile(
              title: Text(categories[index].name),
              trailing: Icon(categories[index].icon),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
