// ignore_for_file: use_late_for_private_fields_and_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/debt_add_language.dart';
import '../../configs/language/payment_language.dart';
import '../../configs/widget/custom_clip_path/custom_clip_path.dart';
import '../../resource/model/model.dart';
import '../../utils/app_currency.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'debt_add_view_model.dart';

class DebtAddScreen extends StatefulWidget {
  const DebtAddScreen({super.key});

  @override
  State<DebtAddScreen> createState() => _DebtAddScreenState();
}

class _DebtAddScreenState extends State<DebtAddScreen> {

  DebtAddViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final data= ModalRoute.of(context)?.settings.arguments;
    return BaseWidget(
      viewModel: DebtAddViewModel(), 
      onViewModelReady: (viewModel) => _viewModel=viewModel!..init(
        data as MyCustomerModel?,),
      builder: (context, viewModel, child) => buildDebtAddScreen(),
    );
  }

  Widget background() {
    return const CustomBackGround();
  }

  Widget buildAppBar() {
    print(_viewModel!.isMe);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeSmall,
        vertical: Size.sizeMedium * 2,
      ),
      child: ListTile(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.COLOR_WHITE,
          ),
        ),
        title: Paragraph(
        content: DebtAddLanguage.addDebt,
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ),
    );
  }

   Widget buildFieldMoney(){
    return AppFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      keyboardType: TextInputType.number,
      labelText: PaymentLanguage.amountOfMoney,
      hintText: PaymentLanguage.enterAmountOfMoney,
      textEditingController: _viewModel!.moneyController,
      isRequired: true,
      onChanged: (value) {
        _viewModel!
          ..validPrice(value.trim())
          ..formatMoney(value.trim())
          ..onSubmit()..setShowRemind(value.trim());
      },
      validator: _viewModel!.messageMoney,
    );
  }

  Widget buildRemindMoney(){
    return _viewModel!.listMoney.isNotEmpty ? Wrap(
      children: List.generate(_viewModel!.listMoney.length, (index) => InkWell(
        onTap: ()=> _viewModel!.setMoneyInput(index),
        child: Padding(
          padding: EdgeInsets.only(right: SizeToPadding.sizeSmall),
          child: Chip(
            label: Paragraph(
              content: AppCurrencyFormat.formatMoneyD(
                _viewModel!.listMoney[index],),
            )
          ),
        ),
      ),) 
    ):const SizedBox();
  }

  Widget buildChoosePersonButton(){
    final nameUser= _viewModel!.myCustomerModel?.fullName?.split(' ').last;
    return ChooseButtonWidget(
      isHideButtonMe: _viewModel!.isHideMe,
      isButton: _viewModel!.isMe,
      nameButtonLeft: DebtAddLanguage.me,
      nameButtonRight: nameUser,
      onTapLeft: (name)=> _viewModel!.setButtonPerson(name),
      onTapRight: (name)=> _viewModel!.setButtonPerson(name),
      titleSelection: DebtAddLanguage.choosePeople,
    );
  }

  Widget buildChooseFormButton(){
    return ChooseButtonWidget(
      isButton: _viewModel!.isPay,
      nameButtonLeft: '${DebtAddLanguage.pay} ${DebtAddLanguage.yourOwes}',
      nameButtonRight: DebtAddLanguage.debit,
      onTapLeft: (name)=> _viewModel!.setButtonForm(name),
      onTapRight: (name)=> _viewModel!.setButtonForm(name),
      titleSelection: DebtAddLanguage.chooseForm,
    );
  }

   Widget buildNote() {
    return AppFormField(
      textEditingController: _viewModel!.noteController,
      labelText: BookingLanguage.note,
      hintText: BookingLanguage.enterNote,
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
      padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
      child: ButtonDateTimeWidget(
        dateTime: _viewModel!.dateTime,
        time: _viewModel!.time,
        onShowSelectDate: showSelectDate,
        onShowSelectTime: showSelectTime,
      ),
    );
  }

  Widget buildButtonApp() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
      child: AppButton(
        enableButton: _viewModel!.enableButton,
        content: UpdateProfileLanguage.submit,
        onTap: () {
          _viewModel!.postDebt();
        },
      ),
    );
  }

  Widget buildFieldMoneyOwes(){
    return FieldNoteWidget(
      hintText: '${_viewModel!.messageOwes}',
      colorHintText: AppColors.Red_Money,
      colorBorder: AppColors.Red_Money,
    );
  }

  Widget buildCardField() {
    return Positioned(
      top: 150,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height-130,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.BLACK_400,
              blurRadius: SpaceBox.sizeVerySmall,
            ),
          ],
          color: AppColors.COLOR_WHITE,
          borderRadius: BorderRadius.all(
            Radius.circular(SpaceBox.sizeLarge),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(SpaceBox.sizeLarge),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildFieldMoneyOwes(),
                buildFieldMoney(),
                buildRemindMoney(),
                buildChoosePersonButton(),
                buildChooseFormButton(),
                buildNote(),
                buildDateTime(),
                buildButtonApp(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDebtAddScreen(){
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [ 
          SizedBox(
            width: double.maxFinite,
            height: MediaQuery.sizeOf(context).height,
          ),
          background(),
          buildAppBar(),
          buildCardField(),
        ],
      ),
    );
  }
}
