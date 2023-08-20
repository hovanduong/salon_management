import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'components/component.dart';
import 'home_detail_viewmodel.dart';

class HomeDetailScreen extends StatefulWidget {
  const HomeDetailScreen({super.key});

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  HomeDetailViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    return BaseWidget<HomeDetailViewModel>(
      viewModel: HomeDetailViewModel(),
      onViewModelReady: (viewModel) =>
          _viewModel = viewModel!..init(id.toString()),
      builder: (context, viewModel, child) => buildDetailsHomeScreen(),
    );
  }

  Widget buildHeader() {
    return CustomerAppBar(
      title: HomeLanguage.details,
      onTap: () => Navigator.pop(context),
    );
  }

  Widget buildImage(int index) {
    final image = _viewModel!.serviceDetails?.images?[index].url;
    return Padding(
      padding: EdgeInsets.only(top: SpaceBox.sizeMedium),
      child: Image.network(
        image ??
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmVfPm6hKZTky6SpTNvEZqaqa8frwh_4Y2Mj4ERoDp0ammsl4LYgjM3VJHBjITmADt8lg&usqp=CAU',
        fit: BoxFit.fitWidth,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget buildPageImage() {
    final sizeImageServiceDetails = _viewModel!.serviceDetails?.images?.length;
    return SizedBox(
      width: double.maxFinite,
      height: SpaceBox.sizeBig * 13,
      child: PageView.builder(
        itemCount: sizeImageServiceDetails,
        scrollDirection: Axis.horizontal,
        controller: _viewModel!.pageController,
        itemBuilder: (context, index) {
          return Transform(
            transform: Matrix4.identity()
              ..rotateX(_viewModel!.currentPageValue - index),
            child: buildImage(index),
          );
        },
      ),
    );
  }

  Widget buildListImage() {
    // final image = _viewModel!.serviceDetails?.images;
    return Stack(
      children: [
        buildPageImage(),
        // Positioned(
        //   bottom: SpaceBox.sizeMedium,
        //   left: SpaceBox.sizeBig*6,
        //   child: SmoothWidget(
        //     controller: _viewModel!.pageController,
        //     count: image?.length,
        //   ))
      ],
    );
  }

  Widget buildNameAndPrice() {
    final price = _viewModel!.serviceDetails?.price.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: 'Hoài Thương 18',
          style: STYLE_BIG.copyWith(
            color: AppColors.BLACK_500,
            fontWeight: FontWeight.bold,
          ),
        ),
        PriceWidget(
          price: price,
        )
      ],
    );
  }

  Widget buildService() {
    final name = _viewModel!.serviceDetails?.name;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SpaceBox.sizeSmall),
      child: Row(
        children: [
          Paragraph(
            content: '${HomeLanguage.service}:',
            style: STYLE_MEDIUM_BOLD.copyWith(
              color: AppColors.BLACK_500,
            ),
          ),
          SizedBox(
            width: SpaceBox.sizeVerySmall,
          ),
          Paragraph(
            content: name ?? '',
            style: STYLE_MEDIUM_BOLD.copyWith(
              color: AppColors.BLACK_500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDescription() {
    final description = _viewModel!.serviceDetails?.description;
    return Paragraph(
      content: description ?? '',
      style: STYLE_MEDIUM.copyWith(
        color: AppColors.BLACK_500,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget buildInfor() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SpaceBox.sizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [buildNameAndPrice(), buildService(), buildDescription()],
      ),
    );
  }

  Widget buildButton() {
    return ButtonWidget(
      content: HomeLanguage.booking,
      onTap: () {},
    );
  }

  Widget buildDetailsHomeScreen() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(SpaceBox.sizeBig),
          child: Column(
            children: [
              buildHeader(),
              buildListImage(),
              buildInfor(),
              buildButton(),
            ],
          ),
        ),
      ),
    );
  }
}
