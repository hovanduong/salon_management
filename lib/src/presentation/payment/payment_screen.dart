// ignore_for_file: use_late_for_private_fields_and_variables

import 'package:flutter/material.dart';
import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/payment_language.dart';
import '../../configs/widget/bottom_sheet/bottom_sheet.dart';
import '../../configs/widget/bottom_sheet/bottom_sheet_single.dart';
import '../../resource/model/my_booking_model.dart';
import '../base/base.dart';

import 'components/components.dart';

import 'components/name_field_widget.dart';
import 'payment.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _ServiceAddScreenState();
}

class _ServiceAddScreenState extends State<PaymentScreen> {
  PaymentViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final dataBooking= ModalRoute.of(context)?.settings.arguments;
    return BaseWidget<PaymentViewModel>(
      viewModel: PaymentViewModel (),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(
        dataBooking as MyBookingModel?,
      ),
      builder: (context, viewModel, child) => buildPaymentScreen(),
    );
  }

  Widget buildPaymentScreen() {
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
            ),
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
      child: buildNote(),
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

  Widget buildButtonAddCustomer(){
    return AppButton(
      content: PaymentLanguage.addMyCustomer,
      enableButton: true,
      onTap: ()=> _viewModel!.goToAddMyCustomer(context),
      width: 150,
    );
  }

  Widget buildInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildButtonAddCustomer(),
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
            ),
          ],
        ),);
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
          ),
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
        ),
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
        title: PaymentLanguage.pay,
      ),
    );
  }

  void showSelectPhone(_) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeToPadding.sizeMedium),
      ),
      isScrollControlled: true,
      builder: (context) => BottomSheetSingle(
        keyboardType: TextInputType.number,
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
      isOnTap: true,
      name: BookingLanguage.phoneNumber,
      hintText: BookingLanguage.enterPhone,
      nameController:_viewModel!.phoneController,
      onTap: () async{
        await _viewModel!.fetchCustomer();
        await _viewModel!.initMapCustomer();
        showSelectPhone(context);
      }, 
    );
  }

  Widget buildAddress() {
    return AppFormField(
      hintText: ServiceAddLanguage.enterAddress,
      labelText: ServiceAddLanguage.address,
      textEditingController: _viewModel!.addressController,
      validator: _viewModel!.addressMsg,
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
          ),
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
        horizontal: SizeToPadding.sizeSmall,
      ),
      child: AppButton(
        content: ServiceAddLanguage.confirm,
        enableButton: _viewModel!.enableButton,
        onTap: () {
          _viewModel!.postBooking();
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
