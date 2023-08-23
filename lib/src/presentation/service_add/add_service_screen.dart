import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'add_service.dart';

class ServiceAddScreen extends StatefulWidget {
  const ServiceAddScreen({super.key});

  @override
  State<ServiceAddScreen> createState() => _ServiceAddScreenState();
}

class _ServiceAddScreenState extends State<ServiceAddScreen> {
  // NOTE: Change language "vi" "en"

  // @override
  // void initState() {
  //   super.initState();
  //   S.load(
  //     const Locale('vi'),
  //   );
  // }

  ServiceAddViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ServiceAddViewModel>(
      viewModel: ServiceAddViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) => buildserviceAdd(),
    );
  }

  //NOTE: MAIN WIDGET
  Widget buildserviceAdd() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildAppbar(),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeToPadding.sizeMedium,
                horizontal: SizeToPadding.sizeMedium,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildServicePhone(),
                  buildServiceTopic(),

                  buildServiceMoney(),
                  // buildServiceTime(),
                  buildServiceDescription(),
                  buildAddress(),
                  buildDateTime(),
                  // buildChoosePhoto(),
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

  Widget buildDateTime() {
    final hours = _viewModel!.dateTime.hour.toString().padLeft(2, '0');

    final minutes = _viewModel!.dateTime.minute.toString().padLeft(2, '0');
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Paragraph(
              content: 'Choose date',
              fontWeight: FontWeight.w600,
            ),
            Paragraph(
              content: 'Choose time',
              fontWeight: FontWeight.w600,
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await _viewModel!.updateDate();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.FIELD_GREEN),
                ),
                child: Text(
                    '${_viewModel!.dateTime.year}/${_viewModel!.dateTime.month}/${_viewModel!.dateTime.day}'),
              ),
            ),
            SizedBox(
              width: SpaceBox.sizeMedium,
            ),
            Expanded(
                child: ElevatedButton(
              onPressed: () async {
                await _viewModel!.updateTime();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.FIELD_GREEN),
              ),
              child: Text('$hours:$minutes'),
            ))
          ],
        ),
      ],
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
        title: ServiceAddLanguage.serviceAdd,
      ),
    );
  }

  Widget buildServicePhone() {
    return AppFormField(
      hintText: 'Enter Service Phone',
      labelText: 'Service Phone',
      validator: _viewModel!.phoneErrorMsg,
      textEditingController: _viewModel!.phoneController,
      onChanged: (value) {
        _viewModel!.checkPhoneInput();
      },
    );
  }

  Widget buildAddress() {
    return AppFormField(
      hintText: 'Enter Address',
      labelText: 'Address',
      validator: _viewModel!.phoneErrorMsg,
      textEditingController: _viewModel!.phoneController,
      onChanged: (value) {},
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

  // Widget buildServiceTime() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       vertical: SizeToPadding.sizeVerySmall,
  //     ),
  //     child: AppFormField(
  //       counterText: '',
  //       maxLenght: 2,
  //       validator: _viewModel!.timeErrorMsg,
  //       labelText: ServiceAddLanguage.timeSpendTogether,
  //       hintText: ServiceAddLanguage.enterAmountOfTime,
  //       keyboardType: TextInputType.datetime,
  //       textEditingController: _viewModel!.timeController,
  //       onChanged: (value) {
  //         _viewModel!
  //           ..checkTimeInput()
  //           ..enableConfirmButton();
  //       },
  //     ),
  //   );
  // }

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

  // Widget buildChoosePhoto() {
  //   return Row(
  //     children: [
  //      _viewModel!.choosePhoto()
  //     ],
  //   );
  // }

  Widget buildConfirmButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium * 2,
      ),
      child: AppButton(
        content: ServiceAddLanguage.confirm,
        enableButton: _viewModel!.enableButton,
        onTap: () {
          _viewModel!
            ..confirmButton()
            ..onServiceList(context);
        },
      ),
    );
  }

  Widget buildCancelText() {
    return InkWell(
      onTap:
          // () {},
          () => Navigator.pop(context),
      child: Paragraph(
        content: ServiceAddLanguage.cancel,
        style: STYLE_MEDIUM_BOLD.copyWith(
          fontSize: FONT_SIZE_LARGE,
          color: AppColors.PRIMARY_PINK,
        ),
      ),
    );
  }
}
