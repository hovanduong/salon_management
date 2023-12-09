// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../resource/model/my_booking_model.dart';
import '../../utils/app_ic_category.dart';
import '../base/base.dart';
import 'booking.dart';
import 'components/components.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _ServiceAddScreenState();
}

class _ServiceAddScreenState extends State<BookingScreen> {
  BookingViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final dataBooking = ModalRoute.of(context)?.settings.arguments;
    return BaseWidget<BookingViewModel>(
      viewModel: BookingViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!
        ..init(
          dataBooking as MyBookingModel?,
        ),
      builder: (context, viewModel, child) => buildLoadingScreen(),
    );
  }

  Widget buildLoadingScreen() {
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
                buildBookingScreen(),
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

  Widget buildBookingScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildAppbar(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildInfo(),
                  buildLineWidget(),
                  // buildServiceInfo(),
                  // buildLineWidget(),
                  buildCategoryAndTime(),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildConfirmButton(),
    );
  }

  Widget buildTitleCategory(){
    return Showcase(
      key: _viewModel!.keyAddCategory,
      description: BookingLanguage.addCategory,
      child: GestureDetector(
        onTap: ()=> _viewModel!.goToAddCategory(context),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Paragraph(
                content: BookingLanguage.selectCategory,
                style: STYLE_MEDIUM.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(Icons.add_circle, color: AppColors.PRIMARY_GREEN,)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListCategory(){
    return Showcase(
      description: BookingLanguage.selectCategory,
      key: _viewModel!.keyCategory,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: SizeToPadding.sizeVeryVerySmall,
          mainAxisSpacing: SizeToPadding.sizeVeryVerySmall,
        ), 
        itemCount: _viewModel!.isShowAll? _viewModel!.listCategory.length+1
          :_viewModel!.listCategory.length,
        itemBuilder: (context, index) {
          if(index==8 && !_viewModel!.isShowAll){
            return buildItemCategory(16,name: BookingLanguage.seeMore);
          }else if(index<8){
            return buildItemCategory(index);
          }else if(_viewModel!.isShowAll){
            if(index==_viewModel!.listCategory.length){
              return buildItemCategory(17,name: BookingLanguage.close);
            }else{
              return buildItemCategory(index);
            }
          }
          return null;
        },
      ),
    );
  }

  Widget buildItemCategory(int index, {String? name}){
    return InkWell(
      onTap: () =>_viewModel!.setCategorySelected(index),
      child: Container(
        padding: EdgeInsets.all(SizeToPadding.sizeMedium),
        decoration: BoxDecoration(
          color: _viewModel!.categoryId==(
            name!=null? 0: _viewModel!.listCategory[index].id)
          ? AppColors.LINEAR_GREEN.withOpacity(0.3)
          : AppColors.COLOR_WHITE,
          border: Border.all(color: AppColors.PRIMARY_GREEN),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              AppIcCategory.getIcCategory(
                name!=null? index:
                int.parse(_viewModel!.listCategory[index].imageId ?? '0'),),
              width: 50,
            ),
            SizedBox(height: SpaceBox.sizeSmall,),
            Paragraph(
              content: name ?? _viewModel!.listCategory[index].name,
              fontWeight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategory(){
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleCategory(),
          buildListCategory(),
        ],
      ),
    );
  }

  Widget buildCategoryAndTime() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeMedium,
        horizontal: SizeToPadding.sizeMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCategory(),
          buildDateTime(),
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

  Widget buildInfoCustomer(){
    return Showcase(
      key: _viewModel!.keyInfoCustomer,
      description: BookingLanguage.infoCustomerShowCase,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeToPadding.sizeMedium,
        ),
        child: Column(
          children: [
            buildFieldPhone(),
            buildName(),
            buildAddress(),
            buildNote(),
          ],
        ),
      ),
    );
  }

  Widget buildInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeToPadding.sizeMedium,
      ),
      child: Column(
        children: [
          buildInfoCustomer(),
          buildFieldMoney(),
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
  //           content: BookingLanguage.intoMoney,
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
  //               style: STYLE_SMALL.copyWith(fontWeight: FontWeight.w500),
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
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             Paragraph(
  //               content: BookingLanguage.selectServices,
  //               style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w500),
  //             ),
  //             const Paragraph(
  //               content: '*',
  //               fontWeight: FontWeight.w600,
  //               color: AppColors.PRIMARY_RED,
  //             ),
  //           ],
  //         ),
  //         const Icon(
  //           Icons.add_circle,
  //           color: AppColors.PRIMARY_GREEN,
  //         ),
  //       ],
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
  //       contentEmpty: BookingLanguage.contentEmptyService,
  //       titleEmpty: BookingLanguage.emptyService,
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

  // Widget buildDiscount() {
  //   return AppFormField(
  //     hintText: '0',
  //     suffixText: '%',
  //     labelText: BookingLanguage.discount,
  //     validator: _viewModel!.discountErrorMsg,
  //     keyboardType: TextInputType.number,
  //     textEditingController: _viewModel!.discountController,
  //     onChanged: (value) {
  //       _viewModel!
  //         ..checkDiscountInput(value)
  //         ..totalDiscount();
  //     },
  //   );
  // }

  Widget buildTitleSelectTime() {
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      child: Paragraph(
        content: BookingLanguage.chooseTime,
        style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600,),
      ),
    );
  }

  Widget buildTimeSelect() {
    return SizedBox(
      height: 180,
      child: CupertinoDatePicker(
        initialDateTime: _viewModel!.dateTime,
        mode: CupertinoDatePickerMode.time,
        minimumDate: DateTime.now(),
        use24hFormat: true,
        onDateTimeChanged: (value) {
          _viewModel!.updateTime(value);
        },
      ),
    );
  }

  Widget buildButtonSelectTime() {
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      child: AppButton(
        content: BookingLanguage.done,
        enableButton: true,
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  dynamic showSelectTime() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height / 2.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleSelectTime(),
            buildTimeSelect(),
            buildButtonSelectTime(),
          ],
        ),
      ),
    );
  }

  dynamic showSelectDate() {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) => SfDateRangePicker(
        minDate: DateTime.now(),
        selectionColor: AppColors.PRIMARY_GREEN,
        todayHighlightColor: AppColors.PRIMARY_GREEN,
        controller: _viewModel!.dateController,
        selectionMode: DateRangePickerSelectionMode.single,
        initialSelectedDate: _viewModel!.dateTime,
        showActionButtons: true,
        showNavigationArrow: true,
        onCancel: () {
          _viewModel!.dateController.selectedDate = null;
          Navigator.pop(context);
        },
        onSubmit: (value) {
          _viewModel!.updateDateTime(value! as DateTime);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildDateTime() {
    return ButtonDateTimeWidget(
      dateTime: _viewModel!.dateTime,
      time: _viewModel!.time,
      onShowSelectDate: showSelectDate,
      onShowSelectTime: showSelectTime,
    );
  }

  Widget buildName() {
    return AppFormField(
      hintText: BookingLanguage.nameCustomer,
      labelText: BookingLanguage.name,
      textEditingController:  _viewModel!.nameController,
      validator: _viewModel!.addressMsg,
    );
  }

  Widget buildAppbar() {
    return Container(
      padding: EdgeInsets.only(
        top: Platform.isAndroid ? 40 : 60,
        bottom: 10,
        left: SizeToPadding.sizeMedium,
        right: SizeToPadding.sizeMedium,
      ),
      color: AppColors.PRIMARY_GREEN,
      child: CustomerAppBar(
        color: AppColors.COLOR_WHITE,
        style: STYLE_LARGE.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.COLOR_WHITE,
        ),
        onTap: () => Navigator.pop(context),
        title: _viewModel!.dataMyBooking == null
            ? BookingLanguage.createAppointment
            : BookingLanguage.bookingEdit,
      ),
    );
  }

  // void showSelectPhone(_) {
  //   _viewModel!.setLoading(false);
  //   showModalBottomSheet(
  //     context: context,
  //     isDismissible: false,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(SizeToPadding.sizeMedium),
  //     ),
  //     isScrollControlled: true,
  //     builder: (context) => BottomSheetSingle(
  //       keyboardType: TextInputType.number,
  //       titleContent: BookingLanguage.selectedCustomer,
  //       listItems: _viewModel!.mapPhone,
  //       initValues: 0,
  //       onTapSubmit: (value) {
  //         _viewModel!
  //           ..setNameCustomer(value)
  //           ..enableConfirmButton();
  //       },
  //     ),
  //   );
  // }

  // Widget buildServicePhone() {
  //   return NameFieldWidget(
  //     isOnTap: true,
  //     name: BookingLanguage.phoneNumber,
  //     hintText: BookingLanguage.selectPhoneNumber,
  //     nameController: _viewModel!.phoneController,
  //     onTap: () {
  //       if (_viewModel!.dataMyBooking == null) {
  //         _viewModel!.setLoading(true);
  //         Future.delayed(
  //           const Duration(milliseconds: 500),
  //           () => showSelectPhone(context),
  //         );
  //       }
  //     },
  //   );
  // }

  Widget buildFieldPhone(){
    return AppFormField(
      textEditingController: _viewModel!.phoneController,
      labelText: BookingLanguage.phoneNumber,
      hintText: BookingLanguage.enterPhone,
      keyboardType: TextInputType.phone,
    );
  }

  Widget buildAddress() {
    return AppFormField(
      // isRequired: true,
      hintText: ServiceAddLanguage.enterAddress,
      labelText: ServiceAddLanguage.address,
      textEditingController: _viewModel!.addressController,
      validator: _viewModel!.addressMsg,
      // onChanged: (value) {
      //   _viewModel!
      //     ..validAddress(value.trim())
      //     ..enableConfirmButton();
      // },
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
  //           content: BookingLanguage.temporary,
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
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeToPadding.sizeVerySmall,
      ),
      child: AppFormField(
        textEditingController: _viewModel!.noteController,
        labelText: BookingLanguage.note,
        hintText: BookingLanguage.enterNote,
        // onChanged: (value) {
        //   _viewModel!.enableConfirmButton();
        // },
      ),
    );
  }

  Widget buildFieldMoney(){
    return Showcase( 
      key: _viewModel!.keyMoney,
      description: BookingLanguage.requiredMoney,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeToPadding.sizeMedium,
        ),
        child: AppFormField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          keyboardType: TextInputType.number,
          labelText: BookingLanguage.amountOfMoney,
          hintText: BookingLanguage.enterAmountOfMoney,
          textEditingController: _viewModel!.moneyController,
          onChanged: (value) {
            _viewModel!
              ..validPrice(value.trim())
              ..formatMoney(value.trim())
              ..enableConfirmButton();
          },
          validator: _viewModel!.messageErrorPrice,
        ),
      ),
    );
  }

  Widget buildConfirmButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeSmall,
      ),
      child: AppButton(
        content: ServiceAddLanguage.confirm,
        enableButton: _viewModel!.enableButton,
        onTap: () {
          _viewModel!.checkDataExist();
        },
      ),
    );
  }

  // Widget buildCancelText() {
  //   return InkWell(
  //     onTap: () => Navigator.pop(context),
  //     child: Paragraph(
  //       content: ServiceAddLanguage.cancel,
  //       style: STYLE_MEDIUM_BOLD.copyWith(
  //         fontSize: FONT_SIZE_LARGE,
  //         color: AppColors.PRIMARY_PINK,
  //       ),
  //     ),
  //   );
  // }
}
