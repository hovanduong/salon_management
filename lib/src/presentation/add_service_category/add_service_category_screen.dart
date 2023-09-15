import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/widget/bottom_sheet/bottom_sheet_multiple.dart';
import '../../configs/widget/custom_clip_path/custom_clip_path.dart';
import '../base/base.dart';
import 'add_servcie_category_viewmodel.dart';

class AddServiceCategoriesScreen extends StatefulWidget {
  const AddServiceCategoriesScreen({super.key});

  @override
  State<AddServiceCategoriesScreen> createState() => _AddServiceCategoriesScreenState();
}

class _AddServiceCategoriesScreenState extends State<AddServiceCategoriesScreen> {

  AddServiceCategoriesViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: AddServiceCategoriesViewModel(), 
      onViewModelReady: (viewModel) => _viewModel= viewModel?..init(),
      builder: (context, viewModel, child) => buildAddServcieCategoriesScreen(),
    );
  }

  Widget buildAppBar(){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeVerySmall,
        vertical: Size.sizeMedium,
      ),
      child: ListTile(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.COLOR_WHITE,),
        ),
        title: Paragraph(
          content: ServiceAddLanguage.serviceAdd,
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

  Widget buildFieldNameService(){
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeBig),
      child: AppFormField(
        labelText: ServiceAddLanguage.serviceName,
        textEditingController: _viewModel!.nameServiceController,
        hintText: ServiceAddLanguage.enterServiceName,
        onChanged: (value) {
          _viewModel!..validNameService(value)
          ..onSubmit();
        },
        validator: _viewModel!.messageErorrNameService,
        isSpace: true, 
      ),
    );
  }

  Widget buildFieldPrice(){
    return AppFormField(
      labelText: ServiceAddLanguage.amountOfMoney,
      textEditingController: _viewModel!.priceController,
      hintText: ServiceAddLanguage.enterAmountOfMoney,
      onChanged: (value) {
        _viewModel!..validPrice(value)
        ..onSubmit();
      },
      validator: _viewModel!.messageErorrPrice,
      isSpace: true, 
    );
  }

  Widget buildFieldCategory(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: 'Selected Categories',
          style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle), 
          color: AppColors.PRIMARY_GREEN,
          onPressed: () async{
            showSelectCategory(context);
          },
        )
      ],
    );
  }

  Widget buildIconRemove(int index){
    return Positioned(
      bottom: 23,
      right: -14,
      child: IconButton(
        onPressed: (){
          _viewModel!..removeCategory(index)..onSubmit()..setCategoryId();
        }, 
        icon: const Icon(Icons.highlight_remove, size: 20, 
          color: AppColors.COLOR_WHITE,),
      ),
    );
  }

  Widget buildSelectedCategory(int index){
    return Stack(
      children: [
        Container(
          width: 110,
          margin: EdgeInsets.only(bottom: SizeToPadding.sizeLarge),
          padding: EdgeInsets.symmetric(
            horizontal: SpaceBox.sizeMedium, 
            vertical: SpaceBox.sizeSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.PRIMARY_GREEN,
            borderRadius: BorderRadius.circular(SpaceBox.sizeSmall),
          ),
          child: Paragraph(
            content: _viewModel!.selectedCategory[index].name,
            color: AppColors.COLOR_WHITE,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        buildIconRemove(index),
      ],
    );
  }

  Widget buildListCategories(){
    return SizedBox(
      height: 100,
      child: GridView.builder(
        itemCount: _viewModel!.selectedCategory.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.8,
          crossAxisSpacing: SpaceBox.sizeSmall,
        ), 
        itemBuilder: (context, index) => buildSelectedCategory(index),
      ),
    );
  }

  Widget buildButtonApp(){
    return AppButton(
      enableButton: _viewModel!.enableSubmit,
      content: UpdateProfileLanguage.submit,
      onTap: () {
        _viewModel!.postService();
      },
    );
  }

  void showSelectCategory(_) {
    showModalBottomSheet(
      context: context, 
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => BottomSheetSingleRadio(
        titleContent: 'Chon Category',
        listItems: _viewModel!.mapCategory,
        initValues: _viewModel!.categoryId,
        // changeColor: _viewModel!.isColorProvinces,
        // onSearch: (value) {
        //   _viewModel!.onSearchCategory(value);
        // },
        onTapSubmit: (value) {
            _viewModel!..changeValueCategory(value)..setCategoryId()..onSubmit();
        },
      ),
    );
  }

  Widget buildCardField(){
    return Positioned(
      top: 150,
      child: Container(
        width: MediaQuery.of(context).size.width - SpaceBox.sizeBig*2,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: AppColors.BLACK_400, blurRadius: SpaceBox.sizeVerySmall)
          ],
          color: AppColors.COLOR_WHITE,
          borderRadius: BorderRadius.all(Radius.circular(SpaceBox.sizeLarge),),
        ),
        child: Padding(
          padding: EdgeInsets.all(SpaceBox.sizeLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFieldNameService(),
              buildFieldPrice(),
              buildFieldCategory(),
              buildListCategories(),
              buildButtonApp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddServcieCategoriesScreen(){
    return SingleChildScrollView(
      child: SafeArea(
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
      ),
    );
  }
}