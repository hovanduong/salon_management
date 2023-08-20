import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import '../routers.dart';
import 'verification_code_viewmodel.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  VerificationViewModel? _viewModel;

  @override
  void initState() {
    listenOTP();
    super.initState();
  }

  Future<void> listenOTP()async{
     await SmsAutoFill().listenForCode();
    print('OTP listen called');
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args= ModalRoute.of(context)!.settings.arguments;
    return BaseWidget<VerificationViewModel>(
      viewModel: VerificationViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel?..init(),
      builder: (context, viewModel, child) {
        return buildSignIn(args);
      },
    );
  }

  Widget buildOTP() {
    return CustomerAppBar(
      title: VerificationLanguage.otp,
      onTap: () async {
        Navigator.pop(context);
      },
    );
  }

  Widget buildVerificationCode() {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeMedium * 2),
      child: Paragraph(
        content: VerificationLanguage.verificationCode,
        style: STYLE_LARGE.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium,
        horizontal: SizeToPadding.sizeLarge,
      ),
      child: Paragraph(
        textAlign: TextAlign.center,
        content: VerificationLanguage.weHaveSentTheCode,
        style: STYLE_MEDIUM,
      ),
    );
  }

  Widget buildPhone(RegisterArguments args) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeLarge,
      ),
      child: Paragraph(
        textAlign: TextAlign.center,
        content: args.userModel!.phone,
        style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildFieldVerify() {
    return AppFormField(
      hintText: VerificationLanguage.verificationCode,
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        _viewModel!.code=value;
        _viewModel!
          ..validateVerificationCode(value)
          ..onNext();
      },
      validator: _viewModel!.messageVerifycation ?? '',
    );
  }

  Widget buildButtonSubmit(RegisterArguments args) {
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeVerySmall),
      child: AppButton(
        enableButton: _viewModel!.enableNext,
        content: VerificationLanguage.submit,
        onTap: (){
          _viewModel!.checkOTP(args);
        },
      ),
    );
  }

  Widget buildAutoField(){
    return const TextFieldPinAutoFill(
      currentCode: '',
    );
  }

  Widget buildSignIn(args) {
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
                buildOTP(),
                buildVerificationCode(),
                buildContent(),
                buildPhone(args),
                buildFieldVerify(),
                buildButtonSubmit(args)
              ],
            ),
          ),
        ),
      ),
    );
  }
}