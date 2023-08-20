import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/booking_language.dart';
import '../../configs/widget/select_date/select_date.dart';
import '../base/base.dart';
import 'booking_viewmodel.dart';
import 'components/component.dart';
import 'components/dropbutton_widget.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {

  BookingViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<BookingViewModel>(
      viewModel: BookingViewModel(),
      onViewModelReady: (viewModel) => _viewModel=viewModel!..init(),
      builder: (context, viewModel, child) => buildBookingScreen(),);
  }

  dynamic showOpenDialog(_) {
    showDialog(
      context: context,
      builder: (context) {
        return WarningOneDialog(
          onTap: () {
            Navigator.pop(context);
          },
          image: AppImages.icPlus,
          title: 'oke',
        );
      },
    );
  }

  Widget buildFieldName(){
    return FieldWidget(
      labelText: BookingLanguage.name,
      content: 'Nguyễn Thị Phương',
      isBorder: true,
    );
  }

  Widget buildFieldService(){
    return DropButtonWidget(
      list: _viewModel!.list, 
      onChanged: (value){
        _viewModel!..setDropValue(value)..validService();
      },
      dropValue: _viewModel!.dropValue,
      labelText: HomeLanguage.service,
      validator: _viewModel!.messageService,
    );
  }

  Widget buildFieldTime(){
    return FieldWidget(
      labelText: BookingLanguage.time,
      content: '2',
    );
  }

  Widget buildFieldPrice(){
    return FieldWidget(
      labelText: BookingLanguage.price,
      content: '200.000',
    );
  }

  Widget buildFieldAddress(){
    return AppFormField(
      labelText: BookingLanguage.address,
      textEditingController: _viewModel!.addressController,
      hintText: BookingLanguage.address,
      onChanged: (value) {
        _viewModel!..validAddress(value)
        ..onSignIn();
      },
      validator: _viewModel!.messageErorAddress,
      isSpace: true, 
    );
  }

  Widget buildFieldHour(){
    return FieldWidget(
      labelText: BookingLanguage.hour,
      content: _viewModel!.dateTime,
      isonTap: true,
      onTap: (){
        showDateDialog();
      },
      validator: _viewModel!.messageHour,
    );
  }
  Widget buildButtonApp(){
    return AppButton(
      enableButton: _viewModel!.enableSignIn,
      content: UpdateProfileLanguage.submit,
      onTap: () {
        if(_viewModel!.dateTime!='hh:mm dd-mm-yyyy' 
        && _viewModel!.dropValue!=_viewModel!.list.first){
          return showOpenDialog(context);
        }else{
          _viewModel!..validHour()..validService();
        }
      },
    );
  }

  Widget buildDateTime() {
    return SelectDropDown(
      height: 200,
      onTap: (){
        _viewModel!.validHour();
        Navigator.pop(context);
      },
      picker: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        initialDateTime: DateTime(2023, 1, 1),
        onDateTimeChanged: (newDateTime) {
          _viewModel!.voidSetDate(newDateTime);
        },
      ),
    );
  }

  dynamic showDateDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return buildDateTime();
      },
    );
  }
  Widget buildBookingScreen(){
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(SpaceBox.sizeBig),
          child: Column(
            children: [
              HeaderWidget(content: HomeLanguage.booking),
              SizedBox(height: SpaceBox.sizeBig,),
              buildFieldName(),
              buildFieldService(),
              buildFieldTime(),
              buildFieldPrice(),
              buildFieldAddress(),
              buildFieldHour(),
              buildButtonApp(),
            ],
          ),
        ),
      ),
    );
  }
}