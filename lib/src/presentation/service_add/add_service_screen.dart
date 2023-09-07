import 'package:flutter/material.dart';
import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'add_service.dart';
import 'components/build_service_widget.dart';
import 'components/name_field_widget.dart';

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
      top: true,
      bottom: false,
      right: false,
      left: false,
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
                  buildName(),
                  buildService(),
                  buildMoney(),
                  buildServiceDescription(),
                  buildAddress(),
                  buildDateTime(),
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

  Widget buildService() {
    return BuildServiceWidget(
      onTap: _viewModel!.addNewField,
      fields: _viewModel!.fields,
    );
  }

  // Widget buildDateTimee() {
  //   final hours = _viewModel!.dateTime.hour.toString().padLeft(2, '0');
  //   final minutes = _viewModel!.dateTime.minute.toString().padLeft(2, '0');
  //   return DateTimeWidget(
  //       onPressedTime: _viewModel!.updateTime(),
  //       time: '$hours:$minutes',
  //       onPressedDay: _viewModel!.updateDate(),
  //       day:
  //           '${_viewModel!.dateTime.year}/${_viewModel!.dateTime.month}/${_viewModel!.dateTime.day}');
  // }

  Widget buildDateTime() {
    final hours = _viewModel!.dateTime.hour.toString().padLeft(2, '0');
    final minutes = _viewModel!.dateTime.minute.toString().padLeft(2, '0');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Paragraph(
              content: ServiceAddLanguage.chooseTime,
              fontWeight: FontWeight.w600,
            ),
            Paragraph(
              content: ServiceAddLanguage.chooseDay,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: () async {
                await _viewModel!.updateTime();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.FIELD_GREEN),
              ),
              child: Paragraph(content: '$hours:$minutes'),
            )),
            SizedBox(
              width: SpaceBox.sizeMedium,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await _viewModel!.updateDate();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.FIELD_GREEN),
                ),
                child: Paragraph(
                    content:
                        '${_viewModel!.dateTime.year}/${_viewModel!.dateTime.month}/${_viewModel!.dateTime.day}'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildName() {
    return NameFieldWidget(
      name: 'Name',
      nameController: _viewModel!.nameController,
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
    return Column(
      children: [
        AppFormField(
          hintText: ServiceAddLanguage.enterPhoneNumber,
          labelText: ServiceAddLanguage.phoneNumber,
          validator: _viewModel!.phoneErrorMsg,
          textEditingController: _viewModel!.phoneController,
          onTap: () {
            _viewModel!.changeIsListViewVisible(false);
          },
          onChanged: (value) {
            print(value);
            if (value.isNotEmpty) {
              _viewModel!.isListViewVisible = true;
              _viewModel!.searchResults =
                  _viewModel!.getContactSuggestions(value);
            } else {
              _viewModel!.isListViewVisible = true;
            }
            _viewModel!
              ..enableConfirmButton()
              ..findName();
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _viewModel!.isListViewVisible
              ? _viewModel!.searchResults.length
              : 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Paragraph(
                content: _viewModel!.searchResults[index].name,
                style: STYLE_MEDIUM,
                fontWeight: FontWeight.w600,
              ),
              subtitle: Paragraph(
                content: _viewModel!.searchResults[index].phoneNumber,
                style: STYLE_MEDIUM,
                fontWeight: FontWeight.w600,
              ),
              onTap: () {
                _viewModel!.updatePhoneNumber(
                    _viewModel!.searchResults[index].phoneNumber);
                _viewModel!.isListViewVisible = false;
              },
            );
          },
        ),
      ],
    );
  }

  Widget buildAddress() {
    return AppFormField(
      hintText: ServiceAddLanguage.enterAddress,
      labelText: ServiceAddLanguage.address,
      textEditingController: _viewModel!.addressController,
      onChanged: (value) {
        _viewModel!.enableConfirmButton();
      },
    );
  }

  Widget buildMoney() {
    return NameFieldWidget(
      name: 'Money',
      nameController: _viewModel!.moneyController,
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
