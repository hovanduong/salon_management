import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
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

  Widget buildHeader(){
    return CustomerAppBar(
      title: ServiceAddLanguage.serviceAdd,
      onTap: (){
        Navigator.pop(context);
      },
    );
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

  Widget buildChooseCategory(Function(void Function()) set){
    return SizedBox(
      height: 500,
      width: double.maxFinite,
      child: ListView.builder(
        itemCount: _viewModel!.list.isEmpty? 0: _viewModel!.list.length,
        itemBuilder: (context, index) => CheckboxListTile(
          value: _viewModel!.isCheck?[index], 
          onChanged: (value) {
            _viewModel!.updateStatusIsCheck(index);
            set(() {
            _viewModel!.isCheck![index]= value!;
            });
          },
          activeColor: AppColors.PRIMARY_GREEN,
          title: Paragraph(content: _viewModel!.list[index],),
        ),
      ),
    );
  }

  dynamic showAddCategory(_){
    _viewModel!.createListIsCheck();
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            buildChooseCategory(setState),
            Padding(
              padding: EdgeInsets.all(SizeToPadding.sizeBig),
              child: AppButton(
                enableButton: true,
                content: UpdateProfileLanguage.submit,
                onTap: () {
                  _viewModel!.setListIsCheck();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },)
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
          onPressed: (){
            showAddCategory(context);
          },
        )
      ],
    );
  }

  Widget buildIconRemove(int index){
    return Positioned(
      bottom: 23,
      right: -5,
      child: IconButton(
        onPressed: (){
          _viewModel!.removeCategory(index);
        }, 
        icon: const Icon(Icons.highlight_remove, size: 15, 
          color: AppColors.COLOR_WHITE,)
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
            vertical: SpaceBox.sizeSmall
          ),
          decoration: BoxDecoration(
            color: AppColors.PRIMARY_GREEN,
            borderRadius: BorderRadius.circular(SpaceBox.sizeSmall)
          ),
          child: Paragraph(
            content: _viewModel!.selectedCategory![index],
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
        itemCount: _viewModel!.selectedCategory!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.2
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
        
      },
    );
  }

  Widget buildAddServcieCategoriesScreen(){
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(SpaceBox.sizeBig),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
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
}