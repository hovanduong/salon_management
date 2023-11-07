// ignore_for_file: use_late_for_private_fields_and_variables, avoid_positional_boolean_parameters

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/payment_language.dart';
import '../base/base.dart';

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
    return BaseWidget<PaymentViewModel>(
      viewModel: PaymentViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) => buildLoadingScreen(),
    );
  }

  Widget buildLoadingScreen(){
    return Scaffold(
      body: StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.online,
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        child: NetworkAwareWidget(
          offlineChild: const ThreeBounceLoading(),
          onlineChild: Container(
            color: AppColors.COLOR_WHITE,
            child: Stack(
              children: [
                buildPaymentScreen(),
                if (_viewModel!.isLoading)
                  const Positioned(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: ThreeBounceLoading(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitleCategory(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall),
      child: Paragraph(
        content: PaymentLanguage.addCategory,
        style: STYLE_MEDIUM.copyWith(
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  Widget buildItemCategory(int index){
    return InkWell(
      onTap: () =>_viewModel!.setCategorySelected(index),
      child: Container(
        padding: EdgeInsets.all(SizeToPadding.sizeMedium),
        decoration: BoxDecoration(
          color: _viewModel!.categorySelected==index
          ? AppColors.LINEAR_GREEN.withOpacity(0.3)
          : AppColors.COLOR_WHITE,
          border: Border.all(color: AppColors.PRIMARY_GREEN),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              _viewModel!.listCategory[index].image??'', 
              width: 50,
            ),
            SizedBox(height: SpaceBox.sizeSmall,),
            Paragraph(
              content: _viewModel!.listCategory[index].name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListCategory(){
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: SizeToPadding.sizeVeryVerySmall,
        mainAxisSpacing: SizeToPadding.sizeVeryVerySmall,
      ), 
      itemCount: _viewModel!.listCategory.length,
      itemBuilder: (context, index) => buildItemCategory(index),
    );
  }

  Widget buildCategory(){
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleCategory(),
          buildListCategory(),
        ],
      ),
    );
  }

  Widget buildPaymentScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildAppbar(),
          buildInfo(),
          buildLineWidget(),
          // buildServiceInfo(),
          buildCategory(),
          buildConfirmButton(),
        ],
      ),
    );
  }

  // Widget buildServiceInfo() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       vertical: SizeToPadding.sizeMedium,
  //       horizontal: SizeToPadding.sizeMedium,
  //     ),
  //     child: Column(
  //       children: [
  //         buildService(),
  //         buildListService(),
  //         if (_viewModel!.selectedService.isNotEmpty)
  //           Column(
  //             children: [
  //               buildTotalNoDis(),
  //               buildMoney(),
  //             ],
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildFieldPhone(){
    return AppFormField(
      textEditingController: _viewModel!.phoneController,
      labelText: PaymentLanguage.phoneNumber,
      hintText: PaymentLanguage.enterPhoneNumber,
      keyboardType: TextInputType.phone,
    );
  }

  Widget buildFieldMoney(){
    return AppFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
      labelText: PaymentLanguage.amountOfMoney,
      hintText: PaymentLanguage.enterAmountOfMoney,
      textEditingController: _viewModel!.moneyController,
      onChanged: (value) {
        _viewModel!
          ..validPrice(value.trim())
          ..formatMoney(value.trim())
          ..enableConfirmButton();
      },
      maxLenght: 15,
      validator: _viewModel!.messageErrorPrice,
      isSpace: true,
    );
  }

  Widget buildButtonSelect(String name, bool isButton){
    return isButton
    ? Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: AppButton(
          enableButton: true,
          content: name,
          onTap: ()=> _viewModel!.setButtonSelect(name),
        ),
      ),
    )
    : Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: AppOutlineButton(
          content: name,
          onTap: () => _viewModel!.setButtonSelect(name),
        ),
      ),
    );
  }

  Widget buildChooseButton(){
    return Row(
      children: [
        buildButtonSelect(
          PaymentLanguage.collectMoney, _viewModel!.isButtonCollect,),
        buildButtonSelect(
          PaymentLanguage.spendingMoney, _viewModel!.isButtonSpending,),
      ],
    );
  }

  Widget buildInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium,
        horizontal: SizeToPadding.sizeMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildFieldPhone(),
          buildName(),
          buildAddress(),
          buildNote(),
          buildFieldMoney(),
          buildChooseButton(),
        ],
      ),
    );
  }

  // Widget buildTotalNoDis() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: SizeToPadding.sizeMedium),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Paragraph(
  //           style: STYLE_LARGE.copyWith(fontWeight: FontWeight.w500),
  //           content: PaymentLanguage.intoMoney,
  //         ),
  //         Paragraph(
  //           style: STYLE_LARGE.copyWith(fontWeight: FontWeight.w500),
  //           content: _viewModel!.moneyController.text,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget buildListService() {
  //   return Wrap(
  //     runSpacing: -5,
  //     spacing: SpaceBox.sizeSmall,
  //     children: List.generate(
  //       _viewModel!.selectedService.length,
  //       buildItemService,
  //     ),
  //   );
  // }

  Widget buildLineWidget() {
    return Container(
      width: double.infinity,
      height: 20,
      decoration: const BoxDecoration(
        color: AppColors.BLACK_200,
      ),
    );
  }

  // Widget buildItemService(int index) {
  //   final serviceName = _viewModel!.selectedService[index].name!.split('/')[0];
  //   final money = _viewModel!.selectedService[index].name!.split('/')[1];

  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Paragraph(
  //               content: serviceName,
  //               style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //             Paragraph(
  //               content: money,
  //               style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         Container(
  //           color: Colors.grey.withOpacity(0.3),
  //           height: 0.5,
  //           width: double.infinity,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget buildService() {
  //   return InkWell(
  //     onTap: () => showSelectService(context),
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Row(
  //             children: [
  //               Paragraph(
  //                 content: BookingLanguage.selectServices,
  //                 style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
  //               ),
  //               const Paragraph(
  //                 content: '*',
  //                 fontWeight: FontWeight.w600,
  //                 color: AppColors.PRIMARY_RED,
  //               ),
  //             ],
  //           ),
  //           const Icon(
  //             Icons.add_circle,
  //             color: AppColors.PRIMARY_GREEN,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void showSelectService(_) {
  //   showModalBottomSheet(
  //     context: context,
  //     isDismissible: true,
  //     isScrollControlled: true,
  //     builder: (context) => BottomSheetMultipleRadio(
  //       titleContent: BookingLanguage.selectServices,
  //       listItems: _viewModel!.mapService,
  //       initValues: _viewModel!.serviceId,
  //       contentEmpty: PaymentLanguage.contentEmptyService,
  //       titleEmpty: PaymentLanguage.emptyService,
  //       onTapSubmit: (value) {
  //         _viewModel!
  //           ..changeValueService(value)
  //           ..setServiceId()
  //           ..calculateTotalPriceByName()
  //           ..enableConfirmButton();
  //       },
  //     ),
  //   );
  // }

  Widget buildName() {
    return AppFormField(
      labelText: PaymentLanguage.name,
      hintText: PaymentLanguage.enterName,
      textEditingController: _viewModel!.nameController,
    );
  }

  Widget buildAppbar() {
    return Container(
      padding: EdgeInsets.only(top: Platform.isAndroid ? 40 : 60, bottom: 10,
        left: SizeToPadding.sizeMedium, right: SizeToPadding.sizeMedium,),
      color: AppColors.PRIMARY_GREEN,
      child: Center(
        child: CustomerAppBar(
          color: AppColors.COLOR_WHITE,
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.COLOR_WHITE,
          ),
          onTap: () => Navigator.pop(context),
          title: PaymentLanguage.pay,
        ),
      ),
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

  // Widget buildMoney() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: SizeToPadding.sizeMedium),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Paragraph(
  //           style: STYLE_BIG.copyWith(fontWeight: FontWeight.w500),
  //           content: PaymentLanguage.temporary,
  //         ),
  //         Paragraph(
  //           style: STYLE_LARGE_BOLD.copyWith(color: AppColors.PRIMARY_RED),
  //           content: _viewModel!.moneyController.text,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildNote() {
    return AppFormField(
      textEditingController: _viewModel!.noteController,
      labelText: BookingLanguage.note,
      hintText: BookingLanguage.enterNote,
      onChanged: (value) {
        _viewModel!.enableConfirmButton();
      },
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
}
