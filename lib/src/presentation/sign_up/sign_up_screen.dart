import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'sign_up.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static String verify = '';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SignUpViewModel>(
      viewModel: SignUpViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel?..init(),
      builder: (context, viewModel, child) {
        return buildSignIn();
      },
    );
  }

  Widget buildRegister() {
    return CustomerAppBar(
      title: SignUpLanguage.signUp,
      onTap: () async {
        Navigator.pop(context);
      },
    );
  }

  Widget buildWelComeBack() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Paragraph(
            content: SignUpLanguage.welcomeBack,
            style: STYLE_MEDIUM,
          ),
          SizedBox(height: SizeToPadding.sizeVerySmall),
          Paragraph(
            content: SignUpLanguage.pleaseSignUp,
            style: STYLE_MEDIUM,
          ),
        ],
      ),
    );
  }

  Widget buildFieldPhoneNumber() {
    return AppFormField(
      labelText: SignInLanguage.phoneNumber,
      hintText: SignInLanguage.enterPhoneNumber,
      keyboardType: TextInputType.phone,
      textEditingController: _viewModel!.phoneController,
      onChanged: (value) {
        _viewModel!
          ..validPhone(value)
          ..onSignUp();
      },
      validator: _viewModel!.messagePhone ?? '',
    );
  }

  Widget buildFieldFullName() {
    return AppFormField(
      labelText: UpdateProfileLanguage.fullName,
      hintText: UpdateProfileLanguage.enterName,
      textEditingController: _viewModel!.fullNameController,
      onChanged: (value) {
        _viewModel!
          ..validFullName(value)
          ..onSignUp();
      },
      validator: _viewModel!.messageFullName ?? '',
    );
  }

  Widget buildFieldEmail() {
    return AppFormField(
      labelText: UpdateProfileLanguage.email,
      hintText: UpdateProfileLanguage.enterEmail,
      textEditingController: _viewModel!.emailController,
      onChanged: (value) {
        _viewModel!
          ..validEmail(value)
          ..onSignUp();
      },
      validator: _viewModel!.messageEmail ?? '',
    );
  }

  Widget buildSelectGender(){
    return DropdownButtonWidget(
      gender: _viewModel!.gender,
      genderList: _viewModel!.genderList,
      onChanged: (value) => _viewModel!.setGender(value),
    );
  }

  Widget buildTitleGender(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryVerySmall),
      child: Paragraph(
        content: UpdateProfileLanguage.selectGender,
        style: STYLE_SMALL.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildGender(){
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleGender(),
          buildSelectGender(),
        ],
      ),
    );
  }

  Widget buildFieldPass() {
    return AppFormField(
      labelText: ChangePasswordLanguage.password,
      hintText: ChangePasswordLanguage.enterPassword,
      textEditingController: _viewModel!.passController,
      obscureText: true,
      onChanged: (value) {
        _viewModel!
          ..validPass(value, _viewModel!.confirmPassController.text.trim())
          ..onSignUp();
      },
      validator: _viewModel!.messagePass ?? '',
    );
  }

  Widget buildFieldConfirmPass() {
    return AppFormField(
      labelText: ChangePasswordLanguage.enterConfirmPass,
      hintText: ChangePasswordLanguage.confirmPass,
      textEditingController: _viewModel!.confirmPassController,
      obscureText: true,
      onChanged: (value) {
        _viewModel!
          ..validConfirmPass(value, _viewModel!.passController.text.trim())
          ..onSignUp();
      },
      validator: _viewModel!.messageConfirmPass ?? '',
    );
  }

  Widget buildButtonSignIn() {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeVerySmall),
      child: AppButton(
        enableButton: _viewModel!.enableNext,
        content: SignUpLanguage.continueSignUp,
        onTap: () {
          _viewModel!.signUp();
        },
      ),
    );
  }

  Widget buildSignIn() {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeToPadding.sizeLarge,
              vertical: SizeToPadding.sizeMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRegister(),
                buildWelComeBack(),
                buildFieldPhoneNumber(),
                buildFieldFullName(),
                buildFieldEmail(),
                buildGender(),
                buildFieldPass(),
                buildFieldConfirmPass(),
                buildButtonSignIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
