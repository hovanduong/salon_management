import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'update_profile.dart';

class UpdateProfileSreen extends StatefulWidget {
  const UpdateProfileSreen({super.key});

  @override
  State<UpdateProfileSreen> createState() => _UpdateProfileSreenState();
}

class Constants{
  static String gender= 'gender';
  static String city= 'city';
}

class _UpdateProfileSreenState extends State<UpdateProfileSreen> {
  UpdateProfileViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    final phone=ModalRoute.of(context)!.settings.arguments;
    return BaseWidget<UpdateProfileViewModel>(
        viewModel: UpdateProfileViewModel(),
        onViewModelReady: (viewModel) => _viewModel = viewModel?..init(),
        builder: (context, viewModel, child) {
          return buildUpdateProfile(phone);
        },);
  }

  Widget buildProfile() {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeMedium,
        bottom: SizeToPadding.sizeBig*2,),
      child: CustomerAppBar(
        title: UpdateProfileLanguage.updateProfile,
        onTap: (){
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildFieldFullName() {
    return AppFormField(
      labelText: UpdateProfileLanguage.fullName,
      hintText: UpdateProfileLanguage.enterName,
      onChanged: (value) {
        _viewModel!
          ..validFullName(value)
          ..onSignIn();
      },
      validator: _viewModel!.messageFullName ?? '',
    );
  }

  Widget buildFieldEmail() {
    return AppFormField(
      labelText: UpdateProfileLanguage.email,
      hintText: UpdateProfileLanguage.enterEmail,
      onChanged: (value) {
        _viewModel!
          ..validEmail(value)
          ..onSignIn();
      },
      validator: _viewModel!.messageEmail ?? '',
    );
  }

  Widget buildButtonSubmit(String phone) {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeBig*3
        ,bottom: SpaceBox.sizeBig,),
      child: AppButton(
        enableButton: _viewModel!.enableSignIn,
        content: UpdateProfileLanguage.submit,
        onTap: (){
          _viewModel!.onToCreatePassword(context, phone);
        },
      ),
    );
  }

  Widget buildSelectGender(){
    return Container(
      height: SpaceBox.sizeLarge*2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpaceBox.sizeVerySmall),
        color: AppColors.PRIMARY_GREEN,
      ),
      child: DropdownButton(
        padding: EdgeInsets.all(SpaceBox.sizeSmall),
        value: _viewModel!.gender,
        dropdownColor: AppColors.PRIMARY_GREEN,
        iconEnabledColor: AppColors.COLOR_WHITE,
        underline: Container(),
        items: _viewModel!.genderList.map((value){
          return DropdownMenuItem(
            value: value,
            child: Paragraph(content: value, 
              style: STYLE_MEDIUM_BOLD.copyWith(color: AppColors.COLOR_WHITE),
            ),
          );
        }).toList(), 
        onChanged: (value) {
          _viewModel!.setGender(value!);
        },
      ),
    );
  }

  Widget buildTitleGender(){
    return Paragraph(
      content: UpdateProfileLanguage.selectGender,
      style: STYLE_MEDIUM_BOLD,
    );
  }

  Widget buildGender(){
    return Row(
      children: [
        buildTitleGender(),
        SizedBox(width: SpaceBox.sizeMedium,),
        buildSelectGender(),
      ],
    );
  }

  Widget buildUpdateProfile(phone) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildProfile(),
                buildFieldFullName(),
                buildFieldEmail(),
                buildGender(),
                buildButtonSubmit(phone),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
