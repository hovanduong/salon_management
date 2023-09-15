import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/widget/select_date/select_date.dart';
import '../../utils/city_vietnam.dart';
import '../base/base.dart';
import 'components/select_field_widget.dart';
import 'update_profile.dart';

class UpdateProfileSreen extends StatefulWidget {
  const UpdateProfileSreen({super.key});

  @override
  State<UpdateProfileSreen> createState() => _UpdateProfileSreenState();
}

class Constants{
  static String gender= 'gender';
  static String city= 'city';
}

class _UpdateProfileSreenState extends State<UpdateProfileSreen> {
  UpdateProfileViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    final phone=ModalRoute.of(context)!.settings.arguments;
    return BaseWidget<UpdateProfileViewModel>(
        viewModel: UpdateProfileViewModel(),
        onViewModelReady: (viewModel) => _viewModel = viewModel?..init(),
        builder: (context, viewModel, child) {
          return buildUpdateProfile(phone);
        },);
  }

  Widget buildProfile() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
      child: CustomerAppBar(
        title: UpdateProfileLanguage.updateProfile,
        onTap: (){
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildAvatarEmpty(){
    return DottedBorder(
      borderType: BorderType.Circle,
      radius: const Radius.circular(12),
      dashPattern: const [4, 4],
      padding: const EdgeInsets.all(6),
      color: AppColors.PRIMARY_PINK,
      child: const CircleAvatar(
        backgroundColor: AppColors.BLACK_300,
        maxRadius: 50,
      ),
    );
  }

  Widget buildAvatar(){
    return InkWell(
      onTap: () => _viewModel!.getImage(),
      child: Stack(
        children:[
          if (_viewModel!.file != null) CircleAvatar(
              radius: 60, 
              backgroundImage: FileImage(_viewModel!.file!),
          ) else buildAvatarEmpty(),
          Positioned(
            top: SpaceBox.sizeSmall,
            right: SpaceBox.sizeSmall,
            child: CircleAvatar(
              backgroundColor: AppColors.COLOR_WHITE,
              maxRadius: SpaceBox.sizeSmall,
              child: Icon(
                Icons.edit, 
                size: SpaceBox.sizeSmall,
                color: AppColors.BLACK_500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildFieldFirstName() {
    return AppFormField(
      labelText: UpdateProfileLanguage.firstName,
      hintText: UpdateProfileLanguage.enterFirstName,
      onChanged: (value) {
        _viewModel!
          ..validFirstName(value)
          ..onSignIn();
      },
      validator: _viewModel!.messageFirstName ?? '',
    );
  }

  Widget buildFieldLastName() {
    return AppFormField(
      labelText: UpdateProfileLanguage.lastName,
      hintText: UpdateProfileLanguage.enterLastName,
      onChanged: (value) {
        _viewModel!
          ..validLastName(value)
          ..onSignIn();

      },
      validator: _viewModel!.messageLastName ?? '',
    );
  }

  Widget buildDateOfBirth() {
    return SelectDropDown(
      height: 200,
      onTap: () {
        Navigator.pop(context);
        _viewModel!.onSignIn();
      },
      picker: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime.now(),
        maximumYear: DateTime.now().year,
        onDateTimeChanged: (newDateTime) {
          _viewModel!.setDate(newDateTime);
        },
      ),
    );
  }

  Widget buildButtonSubmit(String phone) {
    return Padding(
      padding: EdgeInsets.only(bottom: SpaceBox.sizeBig),
      child: AppButton(
        enableButton: _viewModel!.enableSignIn,
        content: UpdateProfileLanguage.submit,
        onTap: (){
          _viewModel!.onToCreatePassword(context, phone);
        },
      ),
    );
  }

  Widget buildSelectPicker(
      BuildContext context, String type, List<String> list,) {
    return SelectDropDown(
      onTap: () {
        if (type == Constants.gender) {
          _viewModel!.setNameGender();
          Navigator.pop(context);
        } else if (type == Constants.city) {
          _viewModel!.setNameCity();
          Navigator.pop(context);
        }
        _viewModel!.onSignIn();
      },
      picker: CupertinoPicker(
        itemExtent: 32,
        backgroundColor: CupertinoColors.white,
        onSelectedItemChanged: (index) {
          if (type == Constants.gender) {
            _viewModel!.changeGenderIndex(index);
          } else if (type == Constants.city) {
            _viewModel!.changSelectedIndex(index);
          }
        },
        children: List<Widget>.generate(list.length, (index) {
          return Center(
            child: Paragraph(
              content: list[index],
              style: STYLE_MEDIUM,
            ),
          );
        }),
      ),
    );
  }

  dynamic showDateDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return buildDateOfBirth();
      },
    );
  }

  dynamic showSelectDialog(List<String>? list, String? type) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return buildSelectPicker(context, type ?? '', list ?? []);
      },
    );
  }

  Widget buildSelectCity() {
    return BuildSelectFieldWidget(
      onTap: (){
        showSelectDialog(AppCityVietNam.listCity,Constants.city);
      },
      validator: _viewModel!.messageCity,
      labelText: UpdateProfileLanguage.city,
      content:
          _viewModel!.nameCity == '-' ? 
          UpdateProfileLanguage.selectCity : _viewModel!.nameCity,
    );
  }

  Widget buildSelectDate() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
      child: BuildSelectFieldWidget(
        onTap: (){
          showDateDialog();
        },
        validator: _viewModel!.messageDate,
        isDate: true,
        labelText: UpdateProfileLanguage.dateOfBirth,
        content: _viewModel!.date == '-' ? 'dd//mm/yyyy' : _viewModel!.date,
      ),
    );
  }

  Widget buildSelectGender() {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeToPadding.sizeSmall),
      child: BuildSelectFieldWidget(
        onTap: (){
          showSelectDialog(_viewModel!.genderList, Constants.gender);
        },
        validator: _viewModel!.messageGender,
        labelText: UpdateProfileLanguage.gender,
        content:
            _viewModel!.gender == '-' ? UpdateProfileLanguage.selectGender : _viewModel!.gender,
      ),
    );
  }

  Widget buildUpdateProfile(phone) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildProfile(),
                buildAvatar(),
                buildFieldFirstName(),
                buildFieldLastName(),
                buildSelectCity(),
                buildSelectDate(),
                buildSelectGender(),
                buildButtonSubmit(phone),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
