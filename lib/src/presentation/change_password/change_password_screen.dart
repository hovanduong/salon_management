// ignore_for_file: type_annotate_public_apis

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'change_password.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ChangePasswordViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<ChangePasswordViewModel>(
      viewModel: ChangePasswordViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel?..init(),
      builder: (context, viewModel, child) {
        return buildChangePassWord();
      },
    );
  }

  Widget buildChangePass() {
    return CustomerAppBar(
      title: ChangePasswordLanguage.changePass,
      onTap: () => Navigator.pop(context),
    );
  }

  Widget buildWarning() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium * 3),
      child: Paragraph(
        textAlign: TextAlign.center,
        content: ChangePasswordLanguage.notificationChangePass,
        style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildFieldPassOld() {
    return AppFormField(
      labelText: ChangePasswordLanguage.oldPass,
      hintText: ChangePasswordLanguage.enterPassword,
      textEditingController: _viewModel!.passOldController,
      obscureText: true,
      onChanged: (value) {
        _viewModel!
          ..validPassOld(value, _viewModel!.passNewController.text.trim())
          ..onEnable();
      },
      validator: _viewModel!.messageOldPass ?? '',
    );
  }

  Widget buildFieldPassNew() {
    return AppFormField(
      labelText: ChangePasswordLanguage.newPass,
      hintText: ChangePasswordLanguage.enterPassword,
      textEditingController: _viewModel!.passNewController,
      obscureText: true,
      onChanged: (value) {
        _viewModel!
          ..validPass(value,
             _viewModel!.confirmPassController.text.trim(),
             _viewModel!.passOldController.text.trim(),)
          ..onEnable();
      },
      validator: _viewModel!.messageNewPass ?? '',
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
          ..validConfirmPass(value, _viewModel!.passNewController.text.trim())
          ..onEnable();
      },
      validator: _viewModel!.messageConfirmPass ?? '',
    );
  }

  Widget buildButtonChangePass() {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeSmall),
      child: AppButton(
        enableButton: _viewModel!.enableButton,
        content: ChangePasswordLanguage.changePass,
        onTap: () {
          _viewModel!.changePassword();
        },
      ),
    );
  }

  Widget buildChangePassWord() {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeToPadding.sizeLarge,
              vertical: SizeToPadding.sizeMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildChangePass(),
                buildWarning(),
                buildFieldPassOld(),
                buildFieldPassNew(),
                buildFieldConfirmPass(),
                buildButtonChangePass(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
