import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import '../booking/components/dropbutton_widget.dart';
import 'add_service.dart';
import 'components/name_field_widget.dart';
import 'components/service_field_widget.dart';

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
      child: Container(
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
                    // Text(_viewModel!.contactName),
                    // buildServiceTopic(),
                    buildName(),
                    buildServicee(),
                    buildMoney(),
                    // buildServiceTime(),
                    buildServiceDescription(),
                    buildAddress(),
                    buildDateTime(),
                    // builDateTimeT(),
                    // buildChoosePhoto(),
                    buildConfirmButton(),
                    buildCancelText(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildServicee() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Paragraph(
              content: 'Chọn dịch vụ',
              fontWeight: FontWeight.w600,
            ),
            GestureDetector(
              onTap: _viewModel!.addNewField,
              child: const Icon(
                Icons.add_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
        Column(
          children: _viewModel!.fields,
        ),
      ],
    );
  }

  // Widget buildService() {
  //   return Column(
  //     children: [
  //       PopupMenuButton<String>(
  //         onSelected: (value) {
  //           _viewModel!.addService(value);
  //           _viewModel!.calculateTotalPrice(value);
  //         },
  //         itemBuilder: (context) => <PopupMenuEntry<String>>[
  //           const PopupMenuItem<String>(
  //             value: 'Dịch vụ 1',
  //             child: Paragraph(content: 'Dịch vụ 1'),
  //           ),
  //           const PopupMenuItem<String>(
  //             value: 'Dịch vụ 2',
  //             child: Paragraph(content: 'Dịch vụ 2'),
  //           ),
  //           const PopupMenuItem<String>(
  //             value: 'Dịch vụ 3',
  //             child: Paragraph(content: 'Dịch vụ 3'),
  //           ),
  //         ],
  //         child: Padding(
  //           padding: EdgeInsets.only(bottom: SpaceBox.sizeMedium),
  //           child: const Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Paragraph(
  //                 content: 'Chọn dịch vụ',
  //                 fontWeight: FontWeight.w600,
  //               ),
  //               Icon(
  //                 Icons.add_circle,
  //                 color: Colors.green,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: _viewModel!.selectedServices
  //             .map(
  //               (service) => ServiceFieldWidget(
  //                 nameService: service,
  //                 onRemove: () {
  //                   _viewModel!.removeService(service);
  //                 },
  //               ),
  //             )
  //             .toList(),
  //       ),
  //     ],
  //   );
  // }
  // Widget builDateTimeT() {
  //   final hours = _viewModel!.dateTime.hour.toString().padLeft(2, '0');

  //   final minutes = _viewModel!.dateTime.minute.toString().padLeft(2, '0');
  //   return DateTimeWidget(
  //     onPressedDay: _viewModel!.updateDate(),
  //     onPressedTime: _viewModel!.updateTime(),
  //     day:
  //         '${_viewModel!.dateTime.year}/${_viewModel!.dateTime.month}/${_viewModel!.dateTime.day}',
  //     time: '$hours:$minutes',
  //   );
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
              child: Text('$hours:$minutes'),
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
                child: Text(
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
            if (value.isNotEmpty && value != null) {
              _viewModel!.isListViewVisible = true;
              _viewModel!.searchResults =
                  _viewModel!.getContactSuggestions(value);
            } else {
              _viewModel!.isListViewVisible = true;
              //  _viewModel!.searchResults.clear();
            }
            _viewModel!
              // ..checkPhoneInput()
              ..enableConfirmButton()
              ..findName();
          },
        ),
        // if (_viewModel!.isListViewVisible &&
        //     _viewModel!.searchResults.isNotEmpty)
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

  // Widget buildServiceTopic() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       vertical: SizeToPadding.sizeVerySmall,
  //     ),
  //     child: AppFormField(
  //       maxLenght: 20,
  //       counterText: '',
  //       validator: _viewModel!.topicErrorMsg,
  //       textEditingController: _viewModel!.topicNameController,
  //       labelText: ServiceAddLanguage.serviceName,
  //       hintText: _viewModel!.name,
  //       onChanged: (value) {
  //         _viewModel!.enableConfirmButton();
  //       },
  //     ),
  //   );
  // }
  Widget buildMoney() {
    return NameFieldWidget(
      name: 'Money',
      nameController: _viewModel!.moneyController,
      // onChanged: _viewModel!.calculateTotalPrice( _viewModel!.moneyController)
    );
  }
  // Widget buildServiceMoney() {
  //   final numberFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  //   final formattedTotalPrice =
  //       numberFormat.format(_viewModel!.calculateTotalPrice());
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       vertical: SizeToPadding.sizeVerySmall,
  //     ),
  //     child: AppFormField(
  //       validator: _viewModel!.moneyErrorMsg,
  //       textEditingController: _viewModel!.moneyController,
  //       labelText: ServiceAddLanguage.amountOfMoney,
  //       hintText: 'Tổng thành tiền: $formattedTotalPrice',
  //       keyboardType: TextInputType.number,
  //       onChanged: (value) {
  //         _viewModel!
  //             // ..checkMoneyInput()
  //             .enableConfirmButton();
  //       },
  //     ),
  //   );
  // }

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
