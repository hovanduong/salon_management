import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
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
    return BaseWidget(
      viewModel: CategoryAddViewModel(), 
      onViewModelReady: (viewModel) => _viewModel= viewModel?..init(),
      builder: (context, viewModel, child) => buildAddCategoriesScreen(),
    );
  }

  Widget buildAppBar(){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeSmall,
        vertical: Size.sizeMedium,
      ),
      child: ListTile(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.COLOR_WHITE,)
        ),
        title: Paragraph(
          content: 'Add Category',
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ),
    );
  }

  Widget backgroundImage() {
    return Image.asset(
      AppImages.backgroundHomePage,
    );
  }

  Widget buildFieldCategory(){
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeBig),
      child: AppFormField(
        labelText: 'Catrgory',
        textEditingController: _viewModel!.categoryController,
        hintText: 'Enter Category',
        onChanged: (value) {
          _viewModel!..validCategory(value)
          ..onSubmit();
        },
        validator: _viewModel!.messageErorrCategory,
        isSpace: true, 
      ),
    );
  }

  Widget buildButtonApp(){
    return AppButton(
      enableButton: _viewModel!.enableButton,
      content: UpdateProfileLanguage.submit,
      onTap: () async{
        await _viewModel!.postCategory(_viewModel!.categoryController.text);
        _viewModel!..categoryController.text=''
        ..onSubmit();
      },
    );
  }

  Widget buildCardField(){
    return Positioned(
      top: 150,
      child: Container(
        width: MediaQuery.of(context).size.width - SpaceBox.sizeBig*2,
        decoration: BoxDecoration(
          color: AppColors.COLOR_WHITE,
          borderRadius: BorderRadius.all(Radius.circular(SpaceBox.sizeLarge),),
        ),
        child: Padding(
          padding: EdgeInsets.all(SpaceBox.sizeLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFieldCategory(),
              buildButtonApp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddCategoriesScreen(){
    return SingleChildScrollView(
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
            ),
            backgroundImage(),
            buildAppBar(),
            buildCardField(),
          ],
        ),
      ),
    );
  }
}