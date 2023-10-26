import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/my_customer_edit_language.dart';
import '../../configs/widget/custom_clip_path/custom_clip_path.dart';
import '../../resource/model/model.dart';
import '../base/base.dart';
import 'components/select_gender_widget.dart';
import 'my_customer_edit.dart';

class MyCustomerEditScreen extends StatefulWidget {
  const MyCustomerEditScreen({super.key});

  @override
  State<MyCustomerEditScreen> createState() => _MyCustomerEditScreenState();
}

class _MyCustomerEditScreenState extends State<MyCustomerEditScreen> {

  MyCustomerEditViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final modelData = ModalRoute.of(context)!.settings.arguments;
    return BaseWidget(
      viewModel: MyCustomerEditViewModel(), 
      onViewModelReady: (viewModel) => _viewModel= viewModel?..init(
        modelData! as MyCustomerModel,),
      builder: (context, viewModel, child) => buildMyCustomerAddScreen(),
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
          icon: const Icon(
            Icons.arrow_back_ios_new, color: AppColors.COLOR_WHITE,),
        ),
        title: Paragraph(
          content: MyCustomerEditLanguage.updateMyCustomer,
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

  Widget buildFieldMail(){
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeBig),
      child: AppFormField(
        labelText: 'Email',
        textEditingController: _viewModel!.mailController,
        hintText: MyCustomerEditLanguage.enterEmail,
        onChanged: (value) {
          _viewModel!..validMail(value)
          ..onSubmit();
        },
        validator: _viewModel!.messageErrorMail,
        isSpace: true, 
      ),
    );
  }

  Widget buildFieldName(){
    return AppFormField(
      labelText: MyCustomerEditLanguage.name,
      textEditingController: _viewModel!.nameController,
      hintText: MyCustomerEditLanguage.enterName,
      onChanged: (value) {
        _viewModel!..validName(value)
        ..onSubmit();
      },
      validator: _viewModel!.messageErrorName,
    );
  }

  Widget buildButtonApp(){
    return AppButton(
      enableButton: _viewModel!.enableSubmit,
      content: MyCustomerEditLanguage.update,
      onTap: () {
        _viewModel!.putMyCustomer();
      },
    );
  }

  Widget buildSelectGender(){
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeMedium),
      child: Row(
        children: [
          Paragraph(
            content: MyCustomerEditLanguage.gender,
            style: STYLE_MEDIUM_BOLD,
          ),
          SizedBox(width: SpaceBox.sizeMedium,),
          SelectGenderWidget(
            onChanged: (value) {
              _viewModel!.setSelectedGender(value);
            },
          ),
        ],
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
              color: AppColors.BLACK_400, blurRadius: SpaceBox.sizeVerySmall,),
          ],
          color: AppColors.COLOR_WHITE,
          borderRadius: BorderRadius.all(Radius.circular(SpaceBox.sizeLarge),),
        ),
        child: Padding(
          padding: EdgeInsets.all(SpaceBox.sizeLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFieldName(),
              buildFieldMail(),
              // buildSelectGender(),
              buildButtonApp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMyCustomerAddScreen(){
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
