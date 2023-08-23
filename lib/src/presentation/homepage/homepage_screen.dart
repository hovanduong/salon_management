import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/configs.dart';
import '../../configs/language/homepage_language.dart';
import '../base/base.dart';
import 'homepage_viewModel.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
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

  Widget buildHomePage() {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: double.infinity,
                height: 365,
              ),
              backgroundImage(),
              nameUser(),
              money(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
          ),
        ],
      ),
    );
  }
}

Widget backgroundImage() {
  return Image.asset(
    AppImages.backgroundHomePage,
  );
}

Widget nameUser() {
  return Positioned(
    top: 60,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Paragraph(
                content: "Good afternoon,",
                style: STYLE_MEDIUM.copyWith(
                  color: AppColors.COLOR_WHITE,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Paragraph(
                content: "Enjelin Morgeana",
                style: STYLE_BIG.copyWith(
                  color: AppColors.COLOR_WHITE,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 140,
          ),
          SvgPicture.asset(AppImages.icBellWhite),
        ],
      ),
    ),
  );
}

Widget money() {
  return Positioned(
    top: 150,
    child: Container(
      width: 371,
      height: 202,
      decoration: const BoxDecoration(
        color: AppColors.PRIMARY_GREEN,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(
                  width: 180,
                ),
                SvgPicture.asset(AppImages.icDots),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Paragraph(
              content: ("\$ 2,548.00"),
              style: STYLE_VERY_BIG.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.15),
                    borderRadius: BorderRadius.all(
                      Radius.circular(999),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_downward_sharp,
                    color: AppColors.COLOR_WHITE,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Paragraph(
                  content: HomePageLanguage.inCome,
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.COLOR_WHITE,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 120,
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.15),
                    borderRadius: BorderRadius.all(
                      Radius.circular(999),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_upward_sharp,
                    color: AppColors.COLOR_WHITE,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Paragraph(
                  content: HomePageLanguage.expenses,
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.COLOR_WHITE,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Paragraph(
                  content: ("\$ 1,840.00"),
                  style: STYLE_LARGE_BIG.copyWith(
                    color: AppColors.COLOR_WHITE,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Paragraph(
                  content: ("\$ 284.00"),
                  style: STYLE_LARGE_BIG.copyWith(
                    color: AppColors.COLOR_WHITE,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget transactionsHistory() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: HomePageLanguage.transactionHistory,
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.BLACK_500,
          ),
        ),
        Paragraph(
          content: HomePageLanguage.seeAll,
          style: STYLE_MEDIUM.copyWith(
            color: AppColors.COLOR_GREY,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget upWork() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Image.asset(
            AppImages.pngUpWork,
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Paragraph(
                content: "Upwork",
                style: STYLE_LARGE_BOLD.copyWith(
                  color: AppColors.BLACK_500,
                ),
              ),
              Paragraph(
                content: "Today",
                style: STYLE_MEDIUM.copyWith(
                  color: AppColors.COLOR_GREY,
                ),
              ),
            ],
          ),
        ],
      ),
      Paragraph(
        content: "+ \$ 850.00",
        style: STYLE_LARGE_BOLD.copyWith(
          color: AppColors.FIELD_GREEN,
        ),
      ),
    ],
  );
}

Widget transfer() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              AppImages.pngTransfer,
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Paragraph(
                  content: "Transfer",
                  style: STYLE_LARGE_BOLD.copyWith(
                    color: AppColors.BLACK_500,
                  ),
                ),
                Paragraph(
                  content: "Yesterday",
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.COLOR_GREY,
                  ),
                ),
              ],
            ),
          ],
        ),
        Paragraph(
          content: "- \$ 85.00",
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.PRIMARY_RED,
          ),
        ),
      ],
    ),
  );
}

Widget paypal() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              AppImages.pngPaypal,
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Paragraph(
                  content: "Palpal",
                  style: STYLE_LARGE_BOLD.copyWith(
                    color: AppColors.BLACK_500,
                  ),
                ),
                Paragraph(
                  content: "Jan 30,2022",
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.COLOR_GREY,
                  ),
                ),
              ],
            ),
          ],
        ),
        Paragraph(
          content: "+ \$ 1,406.00",
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.FIELD_GREEN,
          ),
        ),
      ],
    ),
  );
}

Widget youtube() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              AppImages.pngYoutube,
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Paragraph(
                  content: "Youtube",
                  style: STYLE_LARGE_BOLD.copyWith(
                    color: AppColors.BLACK_500,
                  ),
                ),
                Paragraph(
                  content: "Jan 16, 2022",
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.COLOR_GREY,
                  ),
                ),
              ],
            ),
          ],
        ),
        Paragraph(
          content: "- \$ 11.99",
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.PRIMARY_RED,
          ),
        ),
      ],
    ),
  );
}

Widget sendAgain() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: HomePageLanguage.sendAgain,
          style: STYLE_LARGE_BOLD.copyWith(
            color: AppColors.BLACK_500,
          ),
        ),
        Paragraph(
          content: HomePageLanguage.seeAll,
          style: STYLE_MEDIUM.copyWith(
            color: AppColors.COLOR_GREY,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget listAvatar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(
            Radius.circular(999),
          ),
        ),
        child: Image.asset(
          AppImages.pngAvatar,
        ),
      ),
      Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(
            Radius.circular(999),
          ),
        ),
        child: Image.asset(
          AppImages.pngAvatar,
        ),
      ),
      Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(
            Radius.circular(999),
          ),
        ),
        child: Image.asset(
          AppImages.pngAvatar,
        ),
      ),
      Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(
            Radius.circular(999),
          ),
        ),
        child: Image.asset(
          AppImages.pngAvatar,
        ),
      ),
      Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(
            Radius.circular(999),
          ),
        ),
        child: Image.asset(
          AppImages.pngAvatar,
        ),
      ),
    ],
  );
}
