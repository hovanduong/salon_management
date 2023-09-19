import 'package:flutter/material.dart';
import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/widget/bottom_sheet/bottom_sheet_multiple.dart';
import '../../configs/widget/bottom_sheet/bottom_sheet_single.dart';
import '../base/base.dart';
import 'booking.dart';
import 'components/build_service_widget.dart';
import 'components/name_field_widget.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _ServiceAddScreenState();
}

class _ServiceAddScreenState extends State<BookingScreen> {
  // NOTE: Change language "vi" "en"

  // @override
  // void initState() {
  //   super.initState();
  //   S.load(
  //     const Locale('vi'),
  //   );
  // }

  BookingViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<BookingViewModel>(
      viewModel: BookingViewModel(),
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
                  buildListService(),
                  buildDiscount(),
                  buildMoney(),
                  buildNote(),
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

  Widget buildListService() {
    return Wrap(
        runSpacing: -5,
        spacing: SpaceBox.sizeSmall,
        children: List.generate(
          _viewModel!.selectedService.length,
          buildSelectedService,
        ));
  }

  Widget buildSelectedService(int index) {
    return Chip(
        label: Paragraph(
          content: _viewModel!.selectedService[index].name,
          style: STYLE_MEDIUM_BOLD,
          overflow: TextOverflow.ellipsis,
        ),
        onDeleted: () async {
          await _viewModel!.removeService(index);
          await _viewModel!.setServiceId();
          await _viewModel!.calculateTotalPriceByName(
            isCalculate: true,
          );
        });
  }

  Widget buildService() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: BookingLanguage.selectServices,
          style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle),
          color: AppColors.PRIMARY_GREEN,
          onPressed: () async {
            showSelectCategory(context);
          },
        )
      ],
    );
  }

  void showSelectCategory(_) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => BottomSheetSingleRadio(
        titleContent: BookingLanguage.selectServices,
        listItems: _viewModel!.mapService,
        // initValues: _viewModel!.serviceId,
        onTapSubmit: (value) {
          _viewModel!
            ..changeValueService(value)
            ..setServiceId()
            ..calculateTotalPriceByName();
        },
      ),
    );
  }

  Widget buildDiscount() {
    return AppFormField(
      hintText: '0',
      labelText: BookingLanguage.discount,
      validator: _viewModel!.discountErrorMsg,
      keyboardType: TextInputType.number,
      textEditingController: _viewModel!.discountController,
      onChanged: (value) {
        if (value.isEmpty) {
          _viewModel!.discountController.text = '';
        } else {
          _viewModel!
            ..checkDiscountInput(value)
            ..enableConfirmButton()
            ..totalDiscount();
        }
      },
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
              ),
            ),
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
                      '${_viewModel!.dateTime.year}/${_viewModel!.dateTime.month}/${_viewModel!.dateTime.day}',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildName() {
    return NameFieldWidget(
      name: BookingLanguage.name,
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

  void showSelectPhone(_) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      builder: (context) => BottomSheetSingle(
        titleContent: 'Chọn số điện thoại',
        listItems: _viewModel!.mapPhone,
        initValues: 0,
        onTapSubmit: (value) {
          _viewModel!.setNameCustomer(value);
        },
      ),
    );
  }

  Widget buildServicePhone() {
    return InkWell(
      onTap: () => showSelectPhone(context),
      child: NameFieldWidget(
        name: 'Phone Number',
        nameController: _viewModel!.phoneController,
      ),
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
      name: 'total',
      nameController: _viewModel!.totalController,
    );
  }

  Widget buildNote() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVerySmall,
      ),
      child: AppFormField(
        maxLines: 3,
        validator: _viewModel!.noteErrorMsg,
        textEditingController: _viewModel!.noteController,
        labelText: ServiceAddLanguage.description,
        hintText: ServiceAddLanguage.enterServiceDescription,
        onChanged: (value) {
          _viewModel!
            ..checkNoteInput()
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
        enableButton: true,
        onTap: () {
          _viewModel!
            ..confirmButton()
            ..postService();
        },
      ),
    );
  }

  Widget buildCancelText() {
    return InkWell(
      onTap: () => Navigator.pop(context),
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
