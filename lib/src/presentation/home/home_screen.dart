import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../utils/utils.dart';
import '../base/base.dart';
import '../routers.dart';
import 'components/infor_user_widget.dart';
import 'components/text_gradient.dart';
import 'home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      viewModel: HomeViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel?..init(),
      builder: (context, viewModel, child) => buildHomeScreen(),
    );
  }

  Widget buildIconHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            await AppPref.logout();
            print(await AppPref.getToken());
            setState(() {});
            // FirebaseAuth.instance.signOut();
            // Navigator.pushReplacementNamed(context, Routers.signIn);
          },
          child: SvgPicture.asset(AppImages.icBell),
        ),
        SizedBox(
          width: SpaceBox.sizeMedium,
        ),
        SvgPicture.asset(AppImages.icSetting),
      ],
    );
  }

  Widget buildHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const GradientTextWidget(content: 'Daiting'),
        buildIconHeader(),
      ],
    );
  }

  Widget buildInfor(int index) {
    final description = _viewModel!.listService[index].description;
    final firstImage = _viewModel!.listService[index].images?[0].url;
    final isServiceEmpty = _viewModel!.listService[index].images!.isEmpty;
    final price = _viewModel!.listService[index].price.toString();
    final name = _viewModel!.listService[index].name;
    return InforUserWidget(
      onTap: () => _viewModel!.goToHomeDetails(index),
      address: 'Hương Trà, Thành Phố Huế',
      description: description,
      image: isServiceEmpty ? null : firstImage,
      // name: 'ABC ${_viewModel!.listService[index].id}',
      price: price,
      service: name,
    );
  }

  Widget buildImage() {
    final sizeListService = _viewModel!.listService.length;
    return SizedBox(
      width: double.maxFinite,
      height: 600,
      child: PageView.builder(
        itemCount: sizeListService,
        scrollDirection: Axis.horizontal,
        controller: _viewModel!.pageController,
        itemBuilder: (context, index) {
          return Transform(
            transform: Matrix4.identity()
              ..rotateX(_viewModel!.currentPageValue - index),
            child: buildInfor(index),
          );
        },
      ),
    );
  }

  Widget buildHomeScreen() {
    return SingleChildScrollView(
        child: SafeArea(
      top: true,
      bottom: false,
      right: false,
      left: false,
      child: StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.online,
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        child: NetworkAwareWidget(
          onlineChild: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(SpaceBox.sizeMedium),
                child: Column(
                  children: [
                    buildHeaderWidget(),
                    buildImage(),
                  ],
                ),
              ),
            ],
          ),
          offlineChild: const ThreeBounceLoading(),
        ),
      ),
    ));
  }
}
