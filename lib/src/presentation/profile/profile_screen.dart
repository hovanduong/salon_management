// ignore_for_file: use_late_for_private_fields_and_variables

import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/profile_language.dart';
import '../../configs/widget/custom_clip_path/custom_clip_path.dart';
import '../base/base.dart';
import 'components/setting_profile_list_widget.dart';
import 'profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<ProfileViewModel>(
      viewModel: ProfileViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) => buildProfile(),
    );
  }

  Widget buildBackground() {
    return const CustomBackGround();
  }

  Widget buildHeaderWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeVeryBig,
        vertical: SizeToPadding.sizeVeryBig,
      ),
      child: Center(
        child: Paragraph(
          content: ProfileLanguage.profile,
          style: STYLE_BIG.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.COLOR_WHITE,
          ),
        ),
      ),
    );
  }

  Widget buildAvatarWidget() {
    return Positioned(
      top: 200,
      left: MediaQuery.sizeOf(context).width / 3.1,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.FIELD_GREEN,
            width: 1,
          ),
          color: AppColors.COLOR_WHITE,
          borderRadius: const BorderRadius.all(
            Radius.circular(999),
          ),
        ),
        child: Image.asset(AppImages.imageHome),
      ),
    );
  }

  Widget buildNameUserWidget() {
    return Column(
      children: [
        Paragraph(
          content: 'WELCOME MANAGER',
          style: STYLE_BIG.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildAccountInfoWidget() {
    return SettingProfileListWidget(
      image: AppImages.icPerson,
      title: ProfileLanguage.accountInfo,
      onTap: () => _viewModel!.goToProfileAccount(context),
    );
  }

  Widget buildPersonalProfileWidget() {
    return SettingProfileListWidget(
      image: AppImages.icPeople,
      title: ProfileLanguage.customer,
      onTap: () => _viewModel!.goToMyCustomer(context),
    );
  }

  Widget buildDataAndPrivacyWidget() {
    return SettingProfileListWidget(
      image: AppImages.icPrivacy,
      title: ProfileLanguage.dataAndPrivacy,
    );
  }

  Widget buildLoginAndSecurity() {
    return SettingProfileListWidget(
      image: AppImages.icSecurity,
      title: ProfileLanguage.loginAndSecurity,
    );
  }

  Widget buildLineWidget() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeToPadding.sizeVeryBig,
        right: SizeToPadding.sizeVeryBig,
        top: SizeToPadding.sizeVeryBig,
        bottom: SizeToPadding.sizeMedium,
      ),
      child: Container(
        width: double.infinity,
        height: 0.5,
        decoration: BoxDecoration(
          color: AppColors.BLACK_100,
          border: Border.all(),
        ),
      ),
    );
  }

  Widget buildCategoryWidget() {
    return SettingProfileListWidget(
      image: AppImages.icMessage,
      title: ProfileLanguage.category,
      isOntap: true,
      onTap: () {
        _viewModel!.goToCategory(context);
      },
    );
  }

  Widget buildLogoutWidget() {
    return SettingProfileListWidget(
      image: AppImages.icSecurity,
      title: ProfileLanguage.logout,
      onTap: () async {
        await _viewModel!.showLogOutPopup();
      },
    );
  }

  Widget buildInfoUSer() {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: SpaceBox.sizeSmall),
            child: Paragraph(
              content: _viewModel!.userModel?.fullName,
              style: STYLE_BIG.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Paragraph(
            content: _viewModel!.userModel?.phoneNumber,
            style: STYLE_BIG.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w700,
                fontSize: 16,),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Positioned(
      top: 240,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: SizeToPadding.sizeBig,
        ),
        height: MediaQuery.sizeOf(context).height / 1.5,
        decoration: BoxDecoration(
            color: AppColors.COLOR_WHITE,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SpaceBox.sizeMedium),
              topRight: Radius.circular(SpaceBox.sizeMedium),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.BLACK_400,
                blurStyle: BlurStyle.solid,
                blurRadius: SpaceBox.sizeMedium,
              ),
            ]),
        child: Column(
          children: [
            // buildNameUserWidget(),
            // buildLineWidget(),
            buildAccountInfoWidget(),
            buildPersonalProfileWidget(),
            buildCategoryWidget(),
            // buildLoginAndSecurity(),
            // buildDataAndPrivacyWidget(),
            buildLogoutWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildProfile() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: AppColors.PRIMARY_GREEN,
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height - 100,
                ),
                // buildBackground(),
                // buildHeaderWidget(),
                buildInfoUSer(),
                // buildAvatarWidget(),
                buildBody(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
