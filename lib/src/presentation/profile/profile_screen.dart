import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/profile_language.dart';
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
      builder: (context, viewModel, child) {
        return buildProfile();
      },
    );
  }

  Widget buildProfile() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 365,
                ),
                buildBackgroundImageWidget(),
                buildHeaderWidget(),
                buildAvatarWidget(),
              ],
            ),
            buildNameUserWidget(),
            buildInviteFriendsWidget(),
            buildLineWidget(),
            buildAccountInfoWidget(),
            buildPersonalProfileWidget(),
            buildMessageCenterWidget(),
            buildLoginAndSecurity(),
            buildDataAndPrivacyWidget(),
          ],
        ),
      ),
    );
  }
}

Widget buildBackgroundImageWidget() {
  return Image.asset(
    AppImages.backgroundHomePage,
  );
}

Widget buildHeaderWidget() {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeVeryBig,
        vertical: SizeToPadding.sizeVeryBig * 2.5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.chevron_left,
          size: Size.sizeMedium,
          color: AppColors.COLOR_WHITE,
        ),
        Paragraph(
          content: ProfileLanguage.profile,
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.COLOR_WHITE,
          ),
        ),
        SvgPicture.asset(AppImages.icBellWhite),
      ],
    ),
  );
}

Widget buildAvatarWidget() {
  return Positioned(
    top: 200,
    left: 140,
    child: Container(
      width: 140,
      height: 140,
      decoration: const BoxDecoration(
        color: AppColors.COLOR_WHITE,
        borderRadius: BorderRadius.all(
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
        content: "Enjelin Morgeana",
        style: STYLE_BIG.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: SpaceBox.sizeSmall,
      ),
      Paragraph(
        content: "@enjelin_morgeana",
        style: STYLE_MEDIUM.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.LINEAR_GREEN,
        ),
      ),
    ],
  );
}

Widget buildInviteFriendsWidget() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
    child: SettingProfileListWidget(
      image: AppImages.icDiamond,
      title: ProfileLanguage.inviteFriends,
    ),
  );
}

Widget buildAccountInfoWidget() {
  return SettingProfileListWidget(
    image: AppImages.icPerson,
    title: ProfileLanguage.accountInfo,
  );
}

Widget buildPersonalProfileWidget() {
  return SettingProfileListWidget(
    image: AppImages.icPeople,
    title: ProfileLanguage.personalProfile,
  );
}

Widget buildMessageCenterWidget() {
  return SettingProfileListWidget(
    image: AppImages.icMessage,
    title: ProfileLanguage.messageCenter,
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
    padding: EdgeInsets.symmetric(
      horizontal: SizeToPadding.sizeVeryBig,
    ),
    child: Container(
      width: double.infinity,
      height: 1,
      decoration: BoxDecoration(
        color: AppColors.BLACK_100,
        border: Border.all(),
      ),
    ),
  );
}