import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/my_customer_add_language.dart';
import '../../configs/widget/custom_clip_path/custom_clip_path.dart';
import '../base/base.dart';
import 'my_customer_add_view_model.dart';

class MyCustomerAddScreen extends StatefulWidget {
  const MyCustomerAddScreen({super.key});

  @override
  State<MyCustomerAddScreen> createState() => _MyCustomerAddScreenState();
}

class _MyCustomerAddScreenState extends State<MyCustomerAddScreen> {

  MyCustomerAddViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final isPayment= ModalRoute.of(context)?.settings.arguments;
    return BaseWidget(
      viewModel: MyCustomerAddViewModel(), 
      onViewModelReady: (viewModel) => _viewModel= 
        viewModel?..init(isPayment is bool),
      builder: (context, viewModel, child) => buildMyCustomerAddScreen(),
    );
  }

  Widget buildAppBar(){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeVerySmall,
        vertical: Size.sizeMedium,
      ),
      child: ListTile(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new, color: AppColors.COLOR_WHITE,),
        ),
        title: Paragraph(
          content: MyCustomerAddLanguage.addMyCustomer,
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ),
    );
  }

  Widget background() {
    return const CustomBackGround();
  }

  Widget buildFieldPhone(){
    return Padding(
      padding: EdgeInsets.only(top: SizeToPadding.sizeBig),
      child: AppFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        keyboardType: TextInputType.number,
        labelText: MyCustomerAddLanguage.phoneNumber,
        textEditingController: _viewModel!.phoneController,
        hintText: MyCustomerAddLanguage.enterPhoneNumber,
        onChanged: (value) {
          _viewModel!..validPhone(value)
          ..onSubmit();
        },
        validator: _viewModel!.messageErrorPhone,
        isSpace: true, 
      ),
    );
  }

  Widget buildFieldName(){
    return AppFormField(
      labelText: MyCustomerAddLanguage.name,
      textEditingController: _viewModel!.nameController,
      hintText: MyCustomerAddLanguage.enterName,
      onChanged: (value) {
        _viewModel!..validName(value)
        ..onSubmit();
      },
      validator: _viewModel!.messageErrorName,
      isSpace: true, 
    );
  }

  Widget buildButtonApp(){
    return AppButton(
      enableButton: _viewModel!.enableSubmit,
      content: MyCustomerAddLanguage.submit,
      onTap: () {
        _viewModel!.postMyCustomer();
      },
    );
  }

  Widget buildCardField(){
    return Positioned(
      top: 150,
      child: Container(
        width: MediaQuery.of(context).size.width - SpaceBox.sizeBig*2,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.BLACK_400, blurRadius: SpaceBox.sizeVerySmall,),
          ],
          color: AppColors.COLOR_WHITE,
          borderRadius: BorderRadius.all(Radius.circular(SpaceBox.sizeLarge),),
        ),
        child: Padding(
          padding: EdgeInsets.all(SpaceBox.sizeLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFieldPhone(),
              buildFieldName(),
              buildButtonApp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMyCustomerAddScreen(){
    return SingleChildScrollView(
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
            ),
            background(),
            buildAppBar(),
            buildCardField(),
          ],
        ),
      ),
    );
  }
}
