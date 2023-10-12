// ignore_for_file: use_late_for_private_fields_and_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/homepage_language.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'overview_viewmodel.dart';

class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {

  OverViewViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: OverViewViewModel(), 
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) => buildLoading(),
    );
  }

  Widget buildLoading(){
    return Scaffold(
      body: StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.online,
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        child: NetworkAwareWidget(
          offlineChild: const ThreeBounceLoading(),
          onlineChild: Container(
            color: AppColors.COLOR_WHITE,
            child: Stack(
              children: [
                buildHomePage(),
                if (_viewModel!.isLoading)
                  const Positioned(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: ThreeBounceLoading(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(){
    return Container(
      color: AppColors.PRIMARY_GREEN,
      child: ListTile(
        title: Center(
          child: Paragraph(
            content: HomePageLanguage.overview,
            style: STYLE_LARGE.copyWith(
              color: AppColors.COLOR_WHITE,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      color: AppColors.COLOR_WHITE,
      child: TabBar(
        onTap: (value) {
          _viewModel!.setDataPage(value);
        },
        tabs: [
          Tab(text: HomePageLanguage.yesterday,),
          Tab(text: HomePageLanguage.today,),
          Tab(text: HomePageLanguage.thisWeek,),
          Tab(text: HomePageLanguage.thisMonth,),
        ],
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(
          horizontal: SizeToPadding.sizeBig,),
        indicatorColor: AppColors.PRIMARY_PINK,
        labelStyle: STYLE_MEDIUM_BOLD,
        unselectedLabelColor: AppColors.BLACK_400,
        labelColor: AppColors.PRIMARY_PINK,
      ),
    );
  }

  Widget buildContentTab(){
    return SingleChildScrollView(
      child: Column(
        children: [
          BuildDateWidget(date: _viewModel!.date),
          FieldRevenueWidget(
            totalRevenue: _viewModel!.totalRevenue,
            growthRevenue: _viewModel!.growthRevenue,
            totalBeforeRevenue: _viewModel!.totalBeforeRevenue,
            totalAppointmentConfirm: _viewModel!.totalAppointmentConfirm,
            totalBeforeAppointmentConfirm: _viewModel!.totalBeforeAppointmentConfirm,
            growthAppointmentConfirm: _viewModel!.growthAppointmentConfirm,
            totalAppointmentCancel: _viewModel!.totalAppointmentCancel,
            totalBeforeAppointmentCancel: _viewModel!.totalBeforeAppointmentCancel,
            growthAppointmentCancel: _viewModel!.growthAppointmentCancel,
            totalClient: _viewModel!.totalClient,
            totalBeforeClient: _viewModel!.totalBeforeClient,
            growthClient: _viewModel!.growthClient,
          ),
          ChartWidget(data:_viewModel!.dataChart,
            daysInterval: _viewModel!.daysInterval,),
          SizedBox(height: SpaceBox.sizeMedium,),
          // TopWidget(
          //   title: HomePageLanguage.totalRevenueExpenditure,
          //   widget: Paragraph(content: '0 đ',
          //     style: STYLE_MEDIUM.copyWith(color: AppColors.COLOR_GREY_BLUE),
          //   ),
          // ),
          TopWidget(title: HomePageLanguage.revenue,
            isShowTop: _viewModel!.showRevenue,
            topService: _viewModel!.topService,
            onTap: () => _viewModel!.showListRevenue(),),
          TopWidget(title: HomePageLanguage.topService,
            isShowTop: _viewModel!.showTopService,
            topService: _viewModel!.topService,
            onTap: () => _viewModel!.showListTopService(),),
          TopWidget(title: HomePageLanguage.topServicePackage,
            isShowTop: _viewModel!.showTopServicePackage,
            topService: _viewModel!.topService,
            onTap: () => _viewModel!.showListTopServicePackage(),),
        ],
      ),
    );
  }

  Widget buildTabToday(){
    return buildContentTab();
  }

  Widget buildTabYesterday(){
    return buildContentTab();
  }

  Widget buildTabThisWeek(){
    return  buildContentTab();
  }

  Widget buildTabThisMonth(){
    return buildContentTab();
  }

  Widget buildListTab() {
    return SizedBox(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height - 200,
      child: Padding(
        padding: EdgeInsets.all(SpaceBox.sizeSmall),
        child: TabBarView(
          children: [
            buildTabYesterday(),
            buildTabToday(),
            buildTabThisWeek(),
            buildTabThisMonth(),
          ],
        ),
      ),
    );
  }
  
  Widget buildHomePage() {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        initialIndex: 1,
        child: Column(
          children: [
            buildHeader(),
            buildAppBar(),
            buildListTab(),
          ],
        ),
      ),
    );
  }
}
