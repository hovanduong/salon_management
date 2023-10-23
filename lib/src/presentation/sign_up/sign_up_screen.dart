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
        return buildSignUp();
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

  Widget buildTitleSignUp() {
    return Paragraph(
      content: SignUpLanguage.signUp,
      style: STYLE_BIG.copyWith(fontWeight: FontWeight.w600, fontSize: 25),
    );
  }

  Widget buildWelComeBack() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall),
      child: Paragraph(
        content: SignUpLanguage.pleaseSignUp,
        style: STYLE_MEDIUM,
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

  Widget buildSelectGender() {
    return DropdownButtonWidget(
      gender: _viewModel!.gender,
      genderList: _viewModel!.genderList,
      onChanged: (value) => _viewModel!.setGender(value),
    );
  }

  Widget buildTitleGender() {
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

  Widget buildGender() {
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
        content: SignUpLanguage.signUp,
        onTap: () {
          _viewModel!.signUp();
        },
      ),
    );
  }

  Widget buildNote() {
    return Padding(
      padding: EdgeInsets.only(
          top: SizeToPadding.sizeLarge, bottom: SizeToPadding.sizeVerySmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Paragraph(
            content: SignUpLanguage.haveAccount,
            style: STYLE_MEDIUM,
          ),
          SizedBox(width: SpaceBox.sizeSmall),
          InkWell(
            onTap: () {
              _viewModel!.goToSignIn();
            },
            child: Paragraph(
              content: SignUpLanguage.signIn,
              style: STYLE_MEDIUM.copyWith(
                color: AppColors.PRIMARY_PINK,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFieldSignUp() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeToPadding.sizeBig,
          horizontal: SizeToPadding.sizeSmall,
        ),
        child: Column(
          children: [
            // buildRegister(),
            buildTitleSignUp(),
            buildWelComeBack(),
            buildFieldPhoneNumber(),
            buildFieldFullName(),
            buildFieldEmail(),
            buildGender(),
            buildFieldPass(),
            buildFieldConfirmPass(),
            buildButtonSignIn(),
            buildNote(),
          ],
        ),
      ),
    );
  }

  Widget buildFormSignUp() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeLarge),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              AppColors.COLOR_WHITE,
              AppColors.COLOR_WHITE.withOpacity(0.7),
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: buildFieldSignUp(),
      ),
    );
  }

  Widget buildSignUp() {
    return WillPopScope(
      onWillPop: () => _viewModel!.showExitPopup(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: DecoratedContainer(
            widget: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Paragraph(
                //   content: AppValues.appName,
                //   style: STYLE_BIG.copyWith(
                //     color: AppColors.COLOR_WHITE,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 50,
                //   ),
                // ),
                SizedBox(height: SpaceBox.sizeSmall * 10),
                buildFormSignUp(),
                SizedBox(height: SpaceBox.sizeSmall * 5),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
