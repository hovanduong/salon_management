// ignore_for_file: avoid_positional_boolean_parameters
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/category_language.dart';
import '../../resource/model/my_category_model.dart';
import '../../utils/app_ic_category.dart';
import '../base/base.dart';
import 'category_add.dart';

class CategoryAddScreen extends StatefulWidget {
  const CategoryAddScreen({super.key});

  @override
  State<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  CategoryAddViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final dataCategory = ModalRoute.of(context)?.settings.arguments;
    return BaseWidget(
      viewModel: CategoryAddViewModel(),
      onViewModelReady: (viewModel) =>
          _viewModel = viewModel?..init(dataCategory as CategoryModel?),
      builder: (context, viewModel, child) => buildAddCategoriesScreen(),
    );
  }

  Widget buildHeader() {
    return Container(
      color: AppColors.PRIMARY_GREEN,
      child: Padding(
        padding: EdgeInsets.only(
          top: Platform.isAndroid ? 40 : 60,
          bottom: 10,
          left: SizeToPadding.sizeMedium,
          right: SizeToPadding.sizeMedium,
        ),
        child: CustomerAppBar(
          color: AppColors.COLOR_WHITE,
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.COLOR_WHITE,
          ),
          onTap: () {
            Navigator.pop(context);
          },
          title: _viewModel!.categoryModel != null
              ? CategoryLanguage.editCategory
              : CategoryLanguage.addCategory,
        ),
      )
    );
  }

  // Widget background() {
  //   return const CustomBackGround();
  // }

  Widget buildFieldCategory() {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeBig),
      child: AppFormField(
        focusNode: _viewModel!.focusNode,
        labelText: CategoryLanguage.category,
        textEditingController: _viewModel!.categoryController,
        hintText: CategoryLanguage.enterCategory,
        onChanged: (value) {
          _viewModel!
            ..validCategory(value.trim())
            ..onSubmit();
        },
        validator: _viewModel!.messageErrorCategory,
        isSpace: true,
      ),
    );
  }

  Widget buildTitleIconCategory(){
    return Paragraph(
      content: CategoryLanguage.icon,
      style: STYLE_MEDIUM.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget buildItemCategory(int index){
    return InkWell(
      onTap: () =>_viewModel!.setSelectIconCategory(index),
      child: Container(
        padding: EdgeInsets.all(SizeToPadding.sizeMedium),
        decoration: BoxDecoration(
          color: _viewModel!.selectedCategory== index
          ? AppColors.LINEAR_GREEN.withOpacity(0.3)
          : AppColors.COLOR_WHITE,
          border: Border.all(color: AppColors.PRIMARY_GREEN),
        ),
        child: SvgPicture.asset(
          AppIcCategory.getIcCategory(index),
          width: 50,
        ),
      ),
    );
  }

  Widget buildListIconCategory(){
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: SizeToPadding.sizeVeryVerySmall,
        mainAxisSpacing: SizeToPadding.sizeVeryVerySmall,
      ), 
      itemCount: 16,
      itemBuilder: (context, index) => buildItemCategory(index),
    );
  }

  Widget buildIconCategory(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitleIconCategory(),
        buildListIconCategory(),
      ],
    );
  }

  Widget buildButtonSelect(String name, bool isButton){
    return isButton
    ? Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: AppButton(
          enableButton: true,
          content: name,
          onTap: ()=> _viewModel!.setButtonSelect(name),
        ),
      ),
    )
    : Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: AppOutlineButton(
          content: name,
          onTap: () => _viewModel!.setButtonSelect(name),
        ),
      ),
    );
  }

  Widget buildChooseButton(){
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeMedium),
      child: Row(
        children: [
          buildButtonSelect(
            CategoryLanguage.income, !_viewModel!.isButtonExpenses,),
          buildButtonSelect(
            CategoryLanguage.expenses, _viewModel!.isButtonExpenses,),
        ],
      ),
    );
  }

  Widget buildButtonApp() {
    return Visibility(
      visible: _viewModel!.isShowButton,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
        child: AppButton(
          enableButton: _viewModel!.enableButton,
          content: UpdateProfileLanguage.submit,
          onTap: () {
            _viewModel!.setSourceButton();
          },
        ),
      ),
    );
  }

  Widget buildCardField() {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.sizeOf(context).height-100,
      padding: EdgeInsets.only(
        bottom: SizeToPadding.sizeVeryVeryBig,
        right: SizeToPadding.sizeMedium,
        left: SizeToPadding.sizeMedium,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          buildFieldCategory(),
          buildChooseButton(),
          buildIconCategory(),
        ],
      ),
    );
  }

  Widget buildAddCategoriesScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [ 
            buildHeader(),
            buildCardField(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildButtonApp(),
    );
  }
}
