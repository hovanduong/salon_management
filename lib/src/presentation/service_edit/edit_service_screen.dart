import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/service_edit_Language.dart';
import '../base/base.dart';
import 'edit_service.dart';

class EditServiceScreen extends StatefulWidget {
  const EditServiceScreen({super.key});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  EditServiceViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<EditServiceViewModel>(
      viewModel: EditServiceViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) => buildserviceAdd(),
    );
  }

  // MAIN WIDGET
  Widget buildserviceAdd() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildAppbar(),
            Padding(
              padding: EdgeInsets.only(
                top: SizeToPadding.sizeMedium,
                left: SizeToPadding.sizeMedium,
                right: SizeToPadding.sizeMedium,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildServiceTopic(),
                  buildServiceMoney(),
                  buildServiceTime(),
                  buildServiceDescription(),
                  buildChoosePhoto(),
                  buildConfirmButton(),
                  buildCancelText(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppbar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium,
        horizontal: SizeToPadding.sizeMedium,
      ),
      child: CustomerAppBar(
        onTap: () => Navigator.pop(context),
        title: ServiceEditLanguage.serviceEdit,
      ),
    );
  }

  Widget buildServiceTopic() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVerySmall,
      ),
      child: AppFormField(
        maxLenght: 20,
        counterText: '',
        validator: _viewModel!.topicErrorMsg,
        textEditingController: _viewModel!.topicNameController,
        labelText: ServiceAddLanguage.serviceName,
        hintText: ServiceAddLanguage.enterServiceName,
        onChanged: (value) {
          _viewModel!
            ..checkTopicInput()
            ..enableConfirmButton();
        },
      ),
    );
  }

  Widget buildServiceMoney() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVerySmall,
      ),
      child: AppFormField(
        validator: _viewModel!.moneyErrorMsg,
        textEditingController: _viewModel!.moneyController,
        labelText: ServiceAddLanguage.amountOfMoney,
        hintText: ServiceAddLanguage.enterAmountOfMoney,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          _viewModel!
            ..checkMoneyInput()
            ..enableConfirmButton();
        },
      ),
    );
  }

  Widget buildServiceTime() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVerySmall,
      ),
      child: AppFormField(
        counterText: '',
        maxLenght: 2,
        validator: _viewModel!.timeErrorMsg,
        labelText: ServiceAddLanguage.timeSpendTogether,
        hintText: ServiceAddLanguage.enterAmountOfTime,
        keyboardType: TextInputType.datetime,
        textEditingController: _viewModel!.timeController,
        onChanged: (value) {
          _viewModel!
            ..checkTimeInput()
            ..enableConfirmButton();
        },
      ),
    );
  }

  Widget buildServiceDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVerySmall,
      ),
      child: AppFormField(
        maxLines: 3,
        validator: _viewModel!.descriptionErrorMsg,
        textEditingController: _viewModel!.descriptionController,
        labelText: ServiceAddLanguage.description,
        hintText: ServiceAddLanguage.enterServiceDescription,
        onChanged: (value) {
          _viewModel!
            ..checkDescriptionInput()
            ..enableConfirmButton();
        },
      ),
    );
  }

  Widget buildChoosePhoto() {
    return Row(
      children: [_viewModel!.choosePhoto()],
    );
  }

  Widget buildConfirmButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium * 2,
      ),
      child: AppButton(
        content: ServiceAddLanguage.confirm,
        enableButton: _viewModel!.enableButton,
        onTap: () {
          _viewModel!.confirmButton();
          successPopup(context);
        },
      ),
    );
  }

  dynamic successPopup(_) {
    showDialog(
      context: context,
      builder: (context) => WarningOneDialog(
        image: AppImages.icSuccessCheck,
        title: ServiceEditLanguage.successUpdate,
      ),
    );
  }

  Widget buildCancelText() {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeLarge * 2),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Paragraph(
          content: ServiceAddLanguage.cancel,
          style: STYLE_MEDIUM_BOLD.copyWith(
            fontSize: FONT_SIZE_LARGE,
            color: AppColors.PRIMARY_PINK,
          ),
        ),
      ),
    );
  }
}
