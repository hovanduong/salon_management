// ignore_for_file: use_late_for_private_fields_and_variables, avoid_positional_boolean_parameters

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
import '../../configs/language/payment_language.dart';
import '../../resource/model/model.dart';
import '../../utils/app_currency.dart';
import '../../utils/app_ic_category.dart';
import '../base/base.dart';

import 'components/buildButtonDateTime.dart';
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
    final dataBooking = ModalRoute.of(context)?.settings.arguments;
    return BaseWidget<PaymentViewModel>(
      viewModel: PaymentViewModel(),
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

  Widget buildTitleCategory() {
    return Showcase(
      description: PaymentLanguage.addCategory,
      key: _viewModel!.keyAddCategory,
      child: GestureDetector(
        onTap: () => _viewModel!.goToAddCategory(context),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Paragraph(
                content: PaymentLanguage.selectCategory,
                style: STYLE_MEDIUM.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.add_circle,
                color: AppColors.PRIMARY_GREEN,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItemCategory(int index, {String? name}) {
    return InkWell(
      onTap: () => _viewModel!.setCategorySelected(index),
      child: Container(
        padding: EdgeInsets.all(SizeToPadding.sizeMedium),
        decoration: BoxDecoration(
          color: _viewModel!.selectedCategory == index
              ? AppColors.LINEAR_GREEN.withOpacity(0.3)
              : AppColors.COLOR_WHITE,
          border: Border.all(color: AppColors.PRIMARY_GREEN),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              AppIcCategory.getIcCategory(
                name != null
                    ? index
                    : int.parse(_viewModel!.listCategory[index].imageId ?? '0'),
              ),
              width: 50,
            ),
            SizedBox(
              height: SpaceBox.sizeSmall,
            ),
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

  Widget buildListCategory() {
    return Showcase(
      description: PaymentLanguage.selectCategory,
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
        itemCount: _viewModel!.isShowAll
            ? _viewModel!.listCategory.length + 1
            : _viewModel!.listCategory.length,
        itemBuilder: (context, index) {
          if (index == 8 && !_viewModel!.isShowAll) {
            return buildItemCategory(16, name: PaymentLanguage.seeMore);
          } else if (index < 8) {
            return buildItemCategory(index);
          } else if (_viewModel!.isShowAll) {
            if (index == _viewModel!.listCategory.length) {
              return buildItemCategory(17, name: PaymentLanguage.close);
            } else {
              return buildItemCategory(index);
            }
          }
          return null;
        },
      ),
    );
  }

  Widget buildCategory() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleCategory(),
          buildListCategory(),
        ],
      ),
    );
  }

  Widget buildTitleSelectTime() {
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      child: Paragraph(
        content: BookingLanguage.chooseTime,
        style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildTimeSelect() {
    return SizedBox(
      height: 180,
      child: CupertinoDatePicker(
        initialDateTime: _viewModel!.time,
        mode: CupertinoDatePickerMode.time,
        // minimumDate: DateTime.now(),
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
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
        child: SfDateRangePicker(
          controller: _viewModel!.dateController,
          selectionColor: AppColors.PRIMARY_GREEN,
          todayHighlightColor: AppColors.PRIMARY_GREEN,
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
      ),
    );
  }

  Widget buildDateTime() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeMedium,
        vertical: SizeToPadding.sizeSmall,
      ),
      child: ButtonDateTimeWidget(
        dateTime: _viewModel!.dateTime,
        time: _viewModel!.time,
        onShowSelectDate: showSelectDate,
        onShowSelectTime: showSelectTime,
      ),
    );
  }

  Widget buildCategoryAndTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDateTime(),
        buildCategory(),
        if (Platform.isIOS) const SizedBox(height: 80),
      ],
    );
  }

  Widget buildPaymentScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            buildAppbar(),
            buildInfo(),
            // buildLineWidget(),
            // buildServiceInfo(),
            // buildCategoryAndTime(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildConfirmButton(),
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

  Widget buildFieldPhone() {
    return AppFormField(
      focusNode: _viewModel!.listFocus[0],
      textEditingController: _viewModel!.phoneController,
      labelText: PaymentLanguage.phoneNumber,
      hintText: PaymentLanguage.enterPhoneNumber,
      keyboardType: TextInputType.phone,
    );
  }

  Widget buildRemindMoney() {
    return _viewModel!.listMoney.isNotEmpty
        ? Wrap(
            children: List.generate(
            _viewModel!.listMoney.length,
            (index) => InkWell(
              onTap: () => _viewModel!.setMoneyInput(index),
              child: Padding(
                padding: EdgeInsets.only(right: SizeToPadding.sizeSmall),
                child: Chip(
                    label: Paragraph(
                  content: AppCurrencyFormat.formatMoneyD(
                    _viewModel!.listMoney[index],
                  ),
                )),
              ),
            ),
          ))
        : const SizedBox();
  }

  Widget buildFieldMoney() {
    return Showcase(
      key: _viewModel!.keyMoney,
      description: PaymentLanguage.requiredMoney,
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
          focusNode: _viewModel!.listFocus[4],
          keyboardType: TextInputType.number,
          labelText: PaymentLanguage.amountOfMoney,
          hintText: PaymentLanguage.enterAmountOfMoney,
          textEditingController: _viewModel!.moneyController,
          isRequired: true,
          onChanged: (value) {
            _viewModel!
              ..validPrice(value.trim())
              ..formatMoney(value.trim())
              ..enableConfirmButton()
              ..setShowRemind(value);
          },
          validator: _viewModel!.messageErrorPrice,
        ),
      ),
    );
  }

  Widget buildButtonSelect(String name, bool isButton) {
    return isButton
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: AppButton(
                enableButton: true,
                content: name,
                onTap: () => _viewModel!.setButtonSelect(name),
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

  Widget buildChooseButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
      child: Showcase(
        description: PaymentLanguage.incomeExpenses,
        key: _viewModel!.key,
        child: Row(
          children: [
            buildButtonSelect(
              PaymentLanguage.income,
              !_viewModel!.isButtonSpending,
            ),
            buildButtonSelect(
              PaymentLanguage.expenses,
              _viewModel!.isButtonSpending,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCustomer() {
    return Showcase(
      key: _viewModel!.keyInfoCustomer,
      description: PaymentLanguage.infoCustomerShowCase,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeToPadding.sizeMedium,
        ),
        child: Column(
          children: [
            // buildFieldPhone(),
            buildName(),
            // buildAddress(),
            buildNote(),
          ],
        ),
      ),
    );
  }

  Widget buildInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height - 70,
      width: double.maxFinite,
      padding: EdgeInsets.only(
        top: SizeToPadding.sizeMedium,
        bottom: 85,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildInfoCustomer(),
            buildFieldMoney(),
            buildRemindMoney(),
            buildDateTime(),
            buildChooseButton(),
            buildCategory(),
            if (Platform.isIOS) const SizedBox(height: 80),
          ],
        ),
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
      focusNode: _viewModel!.listFocus[1],
      labelText: PaymentLanguage.name,
      hintText: PaymentLanguage.enterName,
      textEditingController: _viewModel!.nameController,
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
      child: Center(
        child: CustomerAppBar(
          color: AppColors.COLOR_WHITE,
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.COLOR_WHITE,
          ),
          onTap: () => Navigator.pop(context),
          title: _viewModel!.dataMyBooking != null
              ? PaymentLanguage.editPayment
              : PaymentLanguage.payment,
        ),
      ),
    );
  }

  Widget buildAddress() {
    return AppFormField(
      focusNode: _viewModel!.listFocus[2],
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
      focusNode: _viewModel!.listFocus[3],
      textEditingController: _viewModel!.noteController,
      labelText: BookingLanguage.note,
      hintText: BookingLanguage.enterNote,
      onChanged: (value) {
        _viewModel!.enableConfirmButton();
      },
    );
  }

  Widget buildConfirmButton() {
    return Visibility(
      visible: _viewModel!.isShowButton,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeToPadding.sizeSmall,
        ),
        child: AppButton(
          content: _viewModel!.dataMyBooking != null
              ? PaymentLanguage.edit
              : ServiceAddLanguage.confirm,
          enableButton: _viewModel!.enableButton,
          onTap: () {
            _viewModel!.checkCustomer();
          },
        ),
      ),
    );
  }
}
