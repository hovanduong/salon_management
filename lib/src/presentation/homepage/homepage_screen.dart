import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/configs.dart';
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

  @override
  Widget buildHomePage() {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: double.infinity,
                height: 500,
              ),
              backgroundImage(),
              nameUser(),
              Money(),
            ],
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

Widget Money() {
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
                  content: "Total Balance",
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
                  content: "Income",
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.COLOR_GREY,
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
                  content: "Expenses",
                  style: STYLE_MEDIUM.copyWith(
                    color: AppColors.COLOR_GREY,
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
