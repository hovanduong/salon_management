import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import '../routers.dart';
import 'create_password.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  CreatePasswordViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    final infoUser = ModalRoute.of(context)!.settings.arguments;
    return BaseWidget<CreatePasswordViewModel>(
      viewModel: CreatePasswordViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel?..init(),
      builder: (context, viewModel, child) {
        return buildCreatePassWord(infoUser);
      },
    );
  }

  Widget buildCreatePass() {
    return CustomerAppBar(
      title: CreatePasswordLanguage.createPass,
      onTap: () => Navigator.pop(context),
    );
  }

  Widget buildWarning() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium * 3),
      child: Paragraph(
        textAlign: TextAlign.center,
        content: CreatePasswordLanguage.warningCreatePass,
        style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildFieldPass() {
    return AppFormField(
      labelText: CreatePasswordLanguage.password,
      hintText: CreatePasswordLanguage.enterPassword,
      textEditingController: _viewModel!.passController,
      obscureText: true,
      onChanged: (value) {
        _viewModel!
          ..validPass(value, _viewModel!.confirmPassController.text.trim())
          ..onCreatePass();
      },
      validator: _viewModel!.messagePass ?? '',
    );
  }

  Widget buildFieldConfirmPass() {
    return AppFormField(
      labelText: CreatePasswordLanguage.enterConfirmPass,
      hintText: CreatePasswordLanguage.confirmPass,
      textEditingController: _viewModel!.confirmPassController,
      obscureText: true,
      onChanged: (value) {
        _viewModel!
          ..validConfirmPass(value, _viewModel!.passController.text.trim())
          ..onCreatePass();
      },
      validator: _viewModel!.messageConfirmPass ?? '',
    );
  }

  Widget buildButtonCreatePass(RegisterArguments infoUser) {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeSmall),
      child: AppButton(
        enableButton: _viewModel!.enableCreatePass,
        content: CreatePasswordLanguage.createPass,
        onTap: () {
          _viewModel!.sendOTP(infoUser);
        },
      ),
    );
  }

  Widget buildCreatePassWord(infoUser) {
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
                buildCreatePass(),
                buildWarning(),
                buildFieldPass(),
                buildFieldConfirmPass(),
                buildButtonCreatePass(infoUser),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
