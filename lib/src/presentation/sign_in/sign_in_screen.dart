import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SignInViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<SignInViewModel>(
      viewModel: SignInViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel?..init(),
      builder: (context, viewModel, child) {
        return buildSignIn();
      },
    );
  }

  Widget buildLogin() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Paragraph(
        content: SignInLanguage.signIn,
        style: STYLE_BIG.copyWith(fontWeight: FontWeight.w600, fontSize: 25),
      ),
    );
  }

  Widget buildFieldPhoneNumber() {
    return AppFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      labelText: SignInLanguage.phoneNumber,
      hintText: SignInLanguage.enterPhoneNumber,
      keyboardType: TextInputType.phone,
      textEditingController: _viewModel!.phoneController,
      onChanged: (value) {
        _viewModel!
          ..validPhone(value)
          ..onSignIn();
      },
      validator: _viewModel!.messagePhone ?? '',
    );
  }

  Widget buildFieldPass() {
    return AppFormField(
      labelText: SignInLanguage.password,
      hintText: SignInLanguage.enterPassword,
      textEditingController: _viewModel!.passwordController,
      obscureText: true,
      onChanged: (value) {
        _viewModel!
          ..validPass(value)
          ..onSignIn();
      },
      validator: _viewModel!.messagePass ?? '',
    );
  }

  Widget buildForgotPass() {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeSmall),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Paragraph(
              textAlign: TextAlign.end,
              content: SignInLanguage.forgotPass,
              style: STYLE_MEDIUM.copyWith(
                color: AppColors.PRIMARY_PINK,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnSignIn() {
    return AppButton(
      enableButton: _viewModel!.enableSignIn,
      content: SignInLanguage.signIn,
      onTap: () {
        _viewModel!.onLogin(
          phone: _viewModel!.phoneController.text.trim(),
          password: _viewModel!.passwordController.text.trim(),
        );
      },
    );
  }

  Widget buildNote() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Paragraph(
            content: SignInLanguage.contentNotAccount,
            style: STYLE_MEDIUM,
          ),
          SizedBox(width: SpaceBox.sizeSmall),
          InkWell(
            onTap: () {
              _viewModel!.goToSignUp();
            },
            child: Paragraph(
              content: SignInLanguage.nowSignUp,
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

  Widget buildSignIn() {
    return WillPopScope(
      onWillPop: () => _viewModel!.showExitPopup(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: DecoratedContainer(
            widget: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Paragraph(
                  content: AppValues.appName,
                  style: STYLE_BIG.copyWith(
                    color: AppColors.COLOR_WHITE,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                SizedBox(height: SpaceBox.sizeSmall * 5),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeToPadding.sizeLarge),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          AppColors.COLOR_WHITE,
                          AppColors.COLOR_WHITE.withOpacity(0.7)
                        ],
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeToPadding.sizeBig * 2,
                          horizontal: SizeToPadding.sizeSmall,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildLogin(),
                            buildFieldPhoneNumber(),
                            buildFieldPass(),
                            // buildForgotPass(),
                            buildOnSignIn(),
                            buildNote(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
