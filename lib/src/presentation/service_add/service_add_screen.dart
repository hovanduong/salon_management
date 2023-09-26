import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/widget/bottom_sheet/bottom_sheet_multiple.dart';
import '../../configs/widget/custom_clip_path/custom_clip_path.dart';
import '../../utils/app_currency.dart';
import '../base/base.dart';
import 'service_add_view_model.dart';

class ServiceAddScreen extends StatefulWidget {
  const ServiceAddScreen({super.key});

  @override
  State<ServiceAddScreen> createState() => _ServiceAddScreenState();
}

class _ServiceAddScreenState extends State<ServiceAddScreen> {

  ServiceAddViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: ServiceAddViewModel(), 
      onViewModelReady: (viewModel) => _viewModel= viewModel?..init(),
      builder: (context, viewModel, child) => buildAddServiceCategoriesScreen(),
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
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
        ],
        labelText: ServiceAddLanguage.serviceName,
        textEditingController: _viewModel!.nameServiceController,
        hintText: ServiceAddLanguage.enterServiceName,
        onChanged: (value) {
          _viewModel!..validNameService(value)
          ..onSubmit();
        },
        validator: _viewModel!.messageErrorNameService,
        isSpace: true, 
      ),
    );
  }

  Widget buildFieldPrice(){
    return AppFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      labelText: ServiceAddLanguage.amountOfMoney,
      textEditingController: _viewModel!.priceController,
      hintText: ServiceAddLanguage.enterAmountOfMoney,
      onChanged: (value) {
        _viewModel!..validPrice(value)
        ..onSubmit();
        _viewModel!.priceController.text= AppCurrencyFormat.formatMoney(
          int.parse(value),
        );
      },
      validator: _viewModel!.messageErrorPrice,
      isSpace: true, 
    );
  }

  Widget buildFieldCategory(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: ServiceAddLanguage.selectedCategories,
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

  Widget buildSelectedCategory(int index){
    return Chip(
      label: Paragraph(
        content: _viewModel!.selectedCategory[index].name,
        style: STYLE_MEDIUM_BOLD,
        overflow: TextOverflow.ellipsis,
      ),
      onDeleted: () => _viewModel!..removeCategory(index)
        ..onSubmit()..setCategoryId(),
    );
  }

  Widget buildListCategories(){
    return Wrap(
      runSpacing: -5,
      spacing: SpaceBox.sizeSmall,
      children: List.generate(_viewModel!.selectedCategory.length, 
        buildSelectedCategory,)
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
        titleContent: ServiceAddLanguage.selectedCategories,
        listItems: _viewModel!.mapCategory,
        initValues: _viewModel!.categoryId,
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
            BoxShadow(
              color: AppColors.BLACK_400, blurRadius: SpaceBox.sizeVerySmall,)
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

  Widget buildAddServiceCategoriesScreen(){
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
