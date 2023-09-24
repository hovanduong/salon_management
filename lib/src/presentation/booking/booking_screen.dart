import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/widget/bottom_sheet/bottom_sheet.dart';
import '../../configs/widget/bottom_sheet/bottom_sheet_single.dart';
import '../../resource/model/my_booking_model.dart';
import '../base/base.dart';
import 'booking.dart';

import 'components/components.dart';

import 'components/name_field_widget.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _ServiceAddScreenState();
}

class _ServiceAddScreenState extends State<BookingScreen> {
  BookingViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final dataBooking= ModalRoute.of(context)?.settings.arguments;
    return BaseWidget<BookingViewModel>(
      viewModel: BookingViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(
        dataBooking as MyBookingModel?
      ),
      builder: (context, viewModel, child) => buildBookingScreen(),
    );
  }

  Widget buildBookingScreen() {
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
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildInfo(),
                buildLineWidget(),
                buildServiceInfo(),
                buildLineWidget(),
                buildNotes(),
                buildConfirmButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildNotes() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium,
        horizontal: SizeToPadding.sizeMedium,
      ),
      child: Column(
        children: [
          buildNote(),
          buildDateTime(),
        ],
      ),
    );
  }

  Widget buildServiceInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium,
        horizontal: SizeToPadding.sizeMedium,
      ),
      child: Column(
        children: [
          buildService(),
          buildListService(),
          if(_viewModel!.selectedService.isNotEmpty)
            Column(
              children: [
                buildTotalNoDis(),
                buildMoney(),
              ],
            ),
        ],
      ),
    );
  }

  Widget buildInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium,
        horizontal: SizeToPadding.sizeMedium,
      ),
      child: Column(
        children: [
          buildServicePhone(),
          buildName(),
          buildAddress(),
        ],
      ),
    );
  }

  Widget buildTotalNoDis() {
    return Padding(
        padding: EdgeInsets.only(top: SizeToPadding.sizeMedium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Paragraph(
              style: STYLE_LARGE.copyWith(fontWeight: FontWeight.w500),
              content: 'Thành tiền',
            ),
            Paragraph(
              style: STYLE_LARGE.copyWith(fontWeight: FontWeight.w500),
              content: _viewModel!.moneyController.text,
            )
          ],
        ));
  }

  Widget buildListService() {
    return Wrap(
      runSpacing: -5,
      spacing: SpaceBox.sizeSmall,
      children: List.generate(
        _viewModel!.selectedService.length,
        buildItemService,
      ),
    );
  }

  Widget buildLineWidget() {
    return Container(
      width: double.infinity,
      height: 20,
      decoration: const BoxDecoration(
        color: AppColors.BLACK_200,
      ),
    );
  }

  Widget buildItemService(int index) {
    final serviceName = _viewModel!.selectedService[index].name!.split('/')[0];
    final money = _viewModel!.selectedService[index].name!.split('/')[1];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Paragraph(
                content: serviceName,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              Paragraph(
                content: money,
                style: STYLE_SMALL.copyWith(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            color: Colors.grey.withOpacity(0.3),
            height: 0.5,
            width: double.infinity,
          )
        ],
      ),
    );
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
      builder: (context) => BottomSheetMultipleRadio(
        titleContent: BookingLanguage.selectServices,
        listItems: _viewModel!.mapService,
        initValues: _viewModel!.serviceId,
        onTapSubmit: (value) {
          _viewModel!
            ..changeValueService(value)
            ..setServiceId()
            ..calculateTotalPriceByName()
            ..enableConfirmButton();
        },
      ),
    );
  }

  Widget buildDiscount() {
    return AppFormField(
      hintText: '0',
      suffixText: '%',
      labelText: BookingLanguage.discount,
      validator: _viewModel!.discountErrorMsg,
      keyboardType: TextInputType.number,
      textEditingController: _viewModel!.discountController,
      onChanged: (value) {
        _viewModel!
          ..checkDiscountInput(value)
          ..totalDiscount();
      },
    );
  }

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
                      DateFormat('dd/MM/yyyy').format(_viewModel!.dateTime),
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
      hintText: BookingLanguage.nameCustomer,
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
        title:_viewModel!.dataMyBooking==null
          ? BookingLanguage.booking
          : BookingLanguage.bookingEdit,
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
        titleContent: BookingLanguage.selectPhoneNumber,
        listItems: _viewModel!.mapPhone,
        initValues: 0,
        onTapSubmit: (value) {
          _viewModel!.setNameCustomer(value);
        },
      ),
    );
  }

  Widget buildServicePhone() {
    return NameFieldWidget(
      name: BookingLanguage.phoneNumber,
      hintText: BookingLanguage.enterPhone,
      nameController:_viewModel!.phoneController,
      onTap: () {
        if(_viewModel!.dataMyBooking== null){
          showSelectPhone(context);
        }
      } 
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
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(
            style: STYLE_BIG.copyWith(fontWeight: FontWeight.w500),
            content: 'Tạm tính',
          ),
          Paragraph(
            style: STYLE_LARGE_BOLD.copyWith(color: AppColors.PRIMARY_RED),
            content: _viewModel!.moneyController.text,
          )
        ],
      ),
    );
  }

  Widget buildNote() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVerySmall,
      ),
      child: AppFormField(
        maxLines: 3,
        textEditingController: _viewModel!.noteController,
        labelText: BookingLanguage.note,
        hintText: BookingLanguage.enterNote,
        onChanged: (value) {
          _viewModel!.enableConfirmButton();
        },
      ),
    );
  }

  Widget buildConfirmButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium * 2,
        horizontal: SizeToPadding.sizeSmall
      ),
      child: AppButton(
        content: ServiceAddLanguage.confirm,
        enableButton: _viewModel!.enableButton,
        onTap: () {
          if(_viewModel!.dataMyBooking!=null){
            _viewModel!.putBooking();
          }else{
            _viewModel!
              ..confirmButton()
              ..postBooking();
          }
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
