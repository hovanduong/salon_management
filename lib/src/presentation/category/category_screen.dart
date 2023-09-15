import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'category_viewmodel.dart';
import 'components/floating_button_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
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

  Widget buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: SpaceBox.sizeSmall),
      decoration: BoxDecoration(color: AppColors.COLOR_WHITE, boxShadow: [
        BoxShadow(color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig)
      ],),
      child: Padding(
        padding: EdgeInsets.all(SizeToPadding.sizeSmall),
        child: CustomerAppBar(
          onTap: () {
            Navigator.pop(context);
          },
          title: 'Category',
        ),
      ),
    );
  }

  Widget buildCardService(int index, int serviceIndex) {
    return Container(
      margin: EdgeInsets.only(
          bottom: SpaceBox.sizeSmall, right: SpaceBox.sizeMedium,),
      decoration: BoxDecoration(
          color: AppColors.COLOR_WHITE,
          borderRadius: BorderRadius.circular(SpaceBox.sizeSmall),
          boxShadow: [
            BoxShadow(
                color: AppColors.BLACK_300, blurRadius: SpaceBox.sizeVerySmall,)
          ],),
      child: ListTile(
        title: Paragraph(
          content:
              _viewModel!.listCategory[index].myServices?[serviceIndex].name,
          style: STYLE_SMALL.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Paragraph(
          content:
              _viewModel!.listCategory[index].myServices?[serviceIndex].money,
          style: STYLE_SMALL.copyWith(
              fontWeight: FontWeight.w500, color: AppColors.BLACK_300,),
        ),
      ),
    );
  }

  Widget buildListService(int index) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _viewModel!.listCategory[index].myServices?.length,
        itemBuilder: (context, serviceIndex) =>
            buildCardService(index, serviceIndex),);
  }

  Widget buildItemCategory(int index) {
    return GestureDetector(
        onTap: () {
          _viewModel!.setIcon(index);
        },
        child: Icon(
          _viewModel!.listIconCategory[index] == true
              ? Icons.arrow_drop_down_circle
              : Icons.remove_circle,
          color: AppColors.PRIMARY_GREEN,
        ),);
  }

  Widget buildTitleCategory(int index) {
    return Padding(
      padding: EdgeInsets.only(
          right: SizeToPadding.sizeSmall, bottom: SizeToPadding.sizeMedium,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(
            content: _viewModel!.listCategory[index].name,
            style: STYLE_LARGE_BOLD,
          ),
          buildItemCategory(index),
        ],
      ),
    );
  }

  Widget buildContentCategoryWidget(int index) {
    return Padding(
      padding: EdgeInsets.only(
          top: SizeToPadding.sizeMedium, left: SizeToPadding.sizeSmall,),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildTitleCategory(index),
        if (_viewModel!.listIconCategory[index] == false)
          buildListService(index)
        else
          Container(),
      ],),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.COLOR_WHITE, boxShadow: [
          BoxShadow(color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig)
        ],),
        child: ListView.builder(
          itemCount: _viewModel!.listCategory.length,
          itemBuilder: (context, index) => buildContentCategoryWidget(index),
        ),
      ),
    );
  }

  Widget buildItemFloating() {
    return const Column(
      children: [
        BuildFloatingButton(
          heroTag: 'btn1',
          content: 'Add Service',
          iconData: Icons.add,
          // onPressed: (){_viewModel!.goToAddServiceCategory(context);},
        ),
        BuildFloatingButton(
          heroTag: 'btn2',
          content: 'Add Category',
          iconData: Icons.add,
          // onPressed: (){_viewModel!.goToAddCategory(context);},
        ),
      ],
    );
  }

  Widget buildCategory() {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            buildHeader(),
            buildBody(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!_viewModel!.isIconFloatingButton)
              buildItemFloating()
            else
              Container(),
            BuildFloatingButton(
              heroTag: 'btn',
              iconData:
                  _viewModel!.isIconFloatingButton ? Icons.menu : Icons.close,
              onPressed: () {
                _viewModel!.setIconFloating();
              },
            )
          ],
        ),
      ),
    );
  }
}
