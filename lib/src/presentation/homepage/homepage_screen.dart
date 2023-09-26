import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/homepage_language.dart';
import '../../configs/widget/custom_clip_path/custom_clip_path.dart';
import '../base/base.dart';
import 'components/build_avatar.dart';
import 'components/components.dart';
import 'homepage_viewModel.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with AutomaticKeepAliveClientMixin {
  HomePageViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomePageViewModel>(
      viewModel: HomePageViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) {
        return buildHomePage();
      },
    );
  }

  Widget background() {
    return const CustomBackGround();
  }

  Widget buildGreeting() {
    return Paragraph(
      content: 'Good afternoon,',
      style: STYLE_MEDIUM.copyWith(
        color: AppColors.COLOR_WHITE,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget buildUserName() {
    return Paragraph(
      content: 'Enjelin Morgeana',
      style: STYLE_BIG.copyWith(
        color: AppColors.COLOR_WHITE,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget nameUser() {
    return Positioned(
      top: SpaceBox.sizeBig * 2.2,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildGreeting(),
              const SizedBox(height: 5),
              buildUserName(),
            ],
          ),
          SizedBox(
            width: SizeToPadding.sizeBig * 7,
          ),
          SvgPicture.asset(AppImages.icBellWhite),
        ],
      ),
    );
  }

  Widget buildHeaderCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Paragraph(
              content: HomePageLanguage.totalBalance,
              style: STYLE_MEDIUM.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w500,
              ),
            ),
            SvgPicture.asset(AppImages.icChevronDown),
          ],
        ),
        SvgPicture.asset(AppImages.icDots),
      ],
    );
  }

  Widget buildMoney() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SpaceBox.sizeBig,
        top: SpaceBox.sizeVerySmall,
      ),
      child: Paragraph(
        content: r'$ 2,548.00',
        style: STYLE_VERY_BIG.copyWith(
          color: AppColors.COLOR_WHITE,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildIncome() {
    return StatusCardMoney(
      content: HomePageLanguage.inCome,
      icon: Icons.arrow_downward_sharp,
      money: r'$ 1,840.00',
    );
  }

  Widget buildExpenses() {
    return StatusCardMoney(
      content: HomePageLanguage.expenses,
      icon: Icons.arrow_upward,
      money: r'$ 284.00',
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }

  Widget buildIncomeAndExpenses() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildIncome(),
        buildExpenses(),
      ],
    );
  }

  Widget buildCardMoney() {
    return Positioned(
      top: 150,
      child: Container(
        width: 371,
        height: 202,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.BLACK_500,
              blurRadius: SpaceBox.sizeVerySmall,
            ),
          ],
          color: AppColors.PRIMARY_GREEN,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(SpaceBox.sizeLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeaderCard(),
              buildMoney(),
              buildIncomeAndExpenses(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        const SizedBox(
          width: double.infinity,
          height: 365,
        ),
        background(),
        nameUser(),
        buildCardMoney(),
      ],
    );
  }

  Widget transactionsHistory() {
    return SectionTitle(
      titleLeft: HomePageLanguage.transactionHistory,
      titleRight: HomePageLanguage.seeAll,
    );
  }

  Widget listAvatar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SpaceBox.sizeMedium),
      child: SizedBox(
        width: double.maxFinite,
        height: SpaceBox.sizeBig * 2.4,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) => const BuildAvatar(),
        ),
      ),
    );
  }

  Widget upWork() {
    return const Transaction(
      image: AppImages.pngUpWork,
      money: r'+ $ 850.00',
      subtile: 'Today',
      title: 'Upwork',
    );
  }

  Widget transfer() {
    return const Transaction(
      image: AppImages.pngTransfer,
      money: r'- $ 85.00',
      subtile: 'Yesterday',
      title: 'Transfer',
    );
  }

  Widget paypal() {
    return const Transaction(
      image: AppImages.pngPaypal,
      money: r'+ $ 1,406.00',
      subtile: 'Jan 30,2022',
      title: 'Palpal',
    );
  }

  Widget youtube() {
    return const Transaction(
      image: AppImages.pngYoutube,
      money: r'- $ 11.99',
      subtile: 'Jan 16, 2022',
      title: 'Youtube',
    );
  }

  Widget sendAgain() {
    return SectionTitle(
      titleLeft: HomePageLanguage.sendAgain,
      titleRight: HomePageLanguage.seeAll,
    );
  }

  Widget buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SpaceBox.sizeLarge,
      ),
      child: Column(
        children: [
          Column(
            children: [
              transactionsHistory(),
              upWork(),
              transfer(),
              paypal(),
              youtube(),
              sendAgain(),
              listAvatar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildHeader(),
          buildBody(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
