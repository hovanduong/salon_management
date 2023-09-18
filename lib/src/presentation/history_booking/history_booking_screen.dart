import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'history_status_canceled.dart';
import 'history_status_done.dart';
import 'history_status_upcoming.dart';
import 'history_booking_viewmodel.dart';

class HistoryBookingScreen extends StatefulWidget {
  const HistoryBookingScreen({super.key});

  @override
  State<HistoryBookingScreen> createState() => _HistoryBookingScreenState();
}

class _HistoryBookingScreenState extends State<HistoryBookingScreen> {

  HistoryBookingViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: HistoryBookingViewModel(), 
      onViewModelReady: (viewModel) => _viewModel=viewModel!.init(),
      builder: (context, viewModel, child) => buildHistoryScreen(),
    );
  }

  Widget buildHeader() {
    return Container(
      color: AppColors.COLOR_WHITE,
      child: const ListTile(
        title: Center(
          child: Paragraph(
            content: 'Lịch Hẹn',
            style: STYLE_LARGE,
          ),
        ),
        leading: Icon(Icons.arrow_back,
          color: AppColors.BLACK_500,
        ),
        trailing: Icon(null),
      )
    );
  }

  Widget buildAppBar(){
    return Container(
      color: AppColors.COLOR_WHITE,
      child: const TabBar(
        tabs: [
          Tab(text: 'Sắp tới',),  
          Tab(text: 'Đã xong',),
          Tab(text: 'Đã hủy',), 
        ],
        indicatorColor: AppColors.PRIMARY_PINK,
        labelStyle: STYLE_MEDIUM_BOLD,
        unselectedLabelColor: AppColors.BLACK_400,
        labelColor: AppColors.PRIMARY_PINK,
      ),
    );
  }

  Widget buildFirstTab(){
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) => NotificationService(
        dateTime: DateTime.now(),
        address: 'Số 37 Nguyễn Văn Huyên, Quận Cầu Giấy, Hà Nội. Hotline: 0949 969 323',
        price: '100.000 VNĐ',
        service: 'Đi chơi',
        time: '60',
        nameUser: 'Trung Thong',
        phoneNumber: '0931390467',
        widget: setStatusNotification('upComing', 'confirm'),
      ),
    );
  }

  Widget buildSecondTab(){
    return Column(
      children: [
        NotificationService(
          dateTime: DateFormat('dd/MM/yyyy HH:mm').parse('25/8/2023 16:06'),
          address: 'Số 37 Nguyễn Văn Huyên, Quận Cầu Giấy, Hà Nội. Hotline: 0949 969 323',
          price: '100.000 VNĐ',
          service: 'Đi chơi',
          time: '60',
          widget: setStatusNotification('done', 'checkout'),
        ),
      ],
    );
  }

  Widget buildThirdTab(){
    return Column(
      children: [
        NotificationService(
          dateTime: DateFormat('dd/MM/yyyy HH:mm').parse('25/8/2023 16:06'),
          address: 'Số 37 Nguyễn Văn Huyên, Quận Cầu Giấy, Hà Nội. Hotline: 0949 969 323',
          price: '100.000 VNĐ',
          service: 'Đi chơi',
          time: '60',
          widget: setStatusNotification('canceled', 'cancel'),
        ),
      ],
    );
  }

  Widget setStatusNotification(String type, String status){
    switch (type) {
      case 'done':
        return StatusDoneWidget.statusDone(status);
      case 'canceled':
        return StatusCanceledWidget.statusCanceled();
      default:
        return StatusUpComingWidget.statusUpComing(status);
    }
  }

  Widget buildContentTab(){
    return SizedBox(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.all(SpaceBox.sizeMedium),
        child: TabBarView(  
          children: [  
            buildFirstTab(),  
            buildSecondTab(),
            buildThirdTab(),
          ],  
        ),
      ),
    );
  }

  Widget buildHistoryScreen(){
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(),
              buildAppBar(),
              buildContentTab(),
            ],
          ),
        )
      ),
    );
  }
}