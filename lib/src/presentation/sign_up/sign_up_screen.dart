import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
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
      onChanged: (value) {
        _viewModel!.phone = value;
        _viewModel!
          ..validPhone(value)
          ..onNext();
      },
      validator: _viewModel!.messagePhone ?? '',
    );
  }

  Widget buildButtonSignIn() {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeVerySmall),
      child: AppButton(
        enableButton: _viewModel!.enableNext,
        content: SignUpLanguage.continueSignUp,
        onTap: () async {
          await _viewModel!.checkPhoneExists();
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
                buildButtonSignIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
