// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'profile_account_view_model.dart';

class ProfileAccountScreen extends StatefulWidget {
  const ProfileAccountScreen({super.key});

  @override
  State<ProfileAccountScreen> createState() => _ProfileAccountScreenState();
}

class _ProfileAccountScreenState extends State<ProfileAccountScreen> {
  ProfileAccountViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      viewModel: ProfileAccountViewModel(),
      builder: (context, viewModel, child) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: buildProfileAccountScreen(),
      ),
    );
  }

  Widget buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeLarge),
      child: CustomerAppBar(
        onTap: () => Navigator.pop(context),
        title: ProfileAccountLanguage.accountInfo,
        color: AppColors.COLOR_WHITE,
        style: STYLE_LARGE.copyWith(
          color: AppColors.COLOR_WHITE,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget buildNameUser() {
    return ItemWidget(
      title: ProfileAccountLanguage.fullName,
      content: _viewModel!.userModel?.fullName,
    );
  }

  Widget buildPhoneNumber() {
    return ItemWidget(
      title: ProfileAccountLanguage.phoneNumber,
      content: _viewModel!.userModel?.phoneNumber,
      dividerTop: true,
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_GREEN,
        boxShadow: [
          BoxShadow(
            blurRadius: SpaceBox.sizeMedium,
            color: AppColors.BLACK_200,
          ),
        ],
      ),
      child: buildAppBar()
    );
  }

  Widget buildBirthday() {
    return ItemWidget(
      title: ProfileAccountLanguage.dateOfBirth,
    );
  }

  Widget buildGender() {
    return ItemWidget(
      title: ProfileAccountLanguage.gender,
      content: _viewModel!.userModel?.gender,
      dividerTop: true,
    );
  }

  Widget buildEmail() {
    return ItemWidget(
      title: ProfileAccountLanguage.email,
      content: _viewModel!.userModel?.email,
      dividerTop: true,
    );
  }

  Widget buildAddress() {
    return ItemWidget(
      title: ProfileAccountLanguage.address,
      dividerTop: true,
    );
  }

  Widget buildInfoUser() {
    return Container(
      margin: EdgeInsets.only(bottom: SpaceBox.sizeMedium, ),
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: const BoxDecoration(
        color: AppColors.COLOR_WHITE,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            blurStyle: BlurStyle.normal,
            color: AppColors.BLACK_200,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // buildBirthday(),
          // buildGender(),
          buildNameUser(),
          buildPhoneNumber(),
          buildEmail(),
          // buildAddress(),
        ],
      ),
    );
  }

  Widget buildChangePassword() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        boxShadow: [
          BoxShadow(
            blurRadius: SpaceBox.sizeMedium,
            color: AppColors.BLACK_200,
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _viewModel!.gotoChangePass(),
        leading: const CircleAvatar(
          backgroundColor: AppColors.BLACK_500,
          radius: 12,
          child: Icon(
            Icons.lock,
            size: 15,
            color: AppColors.COLOR_WHITE,
          ),
        ),
        title: Paragraph(
          content: ProfileAccountLanguage.changePass,
          style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.BLACK_400,
        ),
      ),
    );
  }

  Widget buildDeleteAccount() {
    return InkWell(
      onTap: () async {
        final result = await showOpenDialogRemoveAccount(context);
        if (result) {
          final isConfirm = await showOpenDialogConfirmRemoveAccount(context);
          if (isConfirm) {
            await _viewModel!.deleteAccount();
            if (_viewModel!.removeAccount) {
              // Navigator.pop(context);
              _viewModel!
                ..showDialogRemoveAccountSuccess()
                ..startDelaySignIn();
              await _viewModel!.logOut();
            }
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: SizeToPadding.sizeSmall),
        padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
        decoration: BoxDecoration(
          color: AppColors.COLOR_WHITE,
          boxShadow: [
            BoxShadow(
              blurRadius: SpaceBox.sizeMedium,
              color: AppColors.BLACK_200,
            ),
          ],
        ),
        child: ItemWidget(
          title: ProfileAccountLanguage.deleteAccount,
        ),
      ),
    );
  }

  Widget buildProfileAccountScreen() {
    return SafeArea(
      top: true,
      left: false,
      bottom: false,
      right: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(),
              buildInfoUser(),
              buildChangePassword(),
              buildDeleteAccount(),
            ],
          ),
        ),
      ),
    );
  }

  dynamic showOpenDialogConfirmRemoveAccount(_) {
    return showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          content: ProfileAccountLanguage.notifiCheckPhone,
          title: ProfileAccountLanguage.confirmDeleteAccount,
          leftButtonName: ProfileAccountLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: ProfileAccountLanguage.confirm,
          controller: _viewModel!.phoneController,
          isForm: true,
          onTapLeft: () {
            Navigator.pop(context, false);
          },
          onTapRight: () async {
            Navigator.pop(context, true);
          },
        );
      },
    );
  }

  dynamic showOpenDialogRemoveAccount(_) {
    return showDialog(
      context: context,
      builder: (context) {
        return WarningDialog(
          content: ProfileAccountLanguage.waningDeleteAccount,
          image: AppImages.icPlus,
          title: ProfileAccountLanguage.notification,
          leftButtonName: ProfileAccountLanguage.cancel,
          color: AppColors.BLACK_500,
          colorNameLeft: AppColors.BLACK_500,
          rightButtonName: ProfileAccountLanguage.confirm,
          onTapLeft: () {
            Navigator.pop(context, false);
          },
          onTapRight: () async {
            Navigator.pop(context, true);
          },
        );
      },
    );
  }
}
