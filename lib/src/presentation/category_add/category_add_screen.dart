import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/category_language.dart';
import '../../configs/widget/custom_clip_path/custom_clip_path.dart';
import '../../resource/model/my_category_model.dart';
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

  Widget buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeSmall,
        vertical: Size.sizeMedium * 2,
      ),
      child: ListTile(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.COLOR_WHITE,
          ),
        ),
        title: Paragraph(
          content: _viewModel!.categoryModel != null
              ? CategoryLanguage.editCategory
              : CategoryLanguage.addCategory,
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ),
    );
  }

  Widget background() {
    return const CustomBackGround();
  }

  Widget buildFieldCategory() {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeBig),
      child: AppFormField(
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

  Widget buildButtonApp() {
    return AppButton(
      enableButton: _viewModel!.enableButton,
      content: UpdateProfileLanguage.submit,
      onTap: () {
        _viewModel!.setSourceButton();
      },
    );
  }

  Widget buildCardField() {
    return Positioned(
      top: 150,
      child: Container(
        width: MediaQuery.of(context).size.width - SpaceBox.sizeBig * 2,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.BLACK_400,
              blurRadius: SpaceBox.sizeVerySmall,
            ),
          ],
          color: AppColors.COLOR_WHITE,
          borderRadius: BorderRadius.all(
            Radius.circular(SpaceBox.sizeLarge),
          ),
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

  Widget buildAddCategoriesScreen() {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
          ),
          background(),
          buildAppBar(),
          buildCardField(),
        ],
      ),
    );
  }
}
