import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../base/base.dart';
import 'booking_detail_view_model.dart';
import 'components/components.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {

  BookingDetailsViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      viewModel: BookingDetailsViewModel(), 
      builder: (context, viewModel, child) => buildBookingDetailsScreen(),
    );
  }

  Widget buildAddress(){
    return ListTile(
      minLeadingWidth: SpaceBox.sizeSmall,
      leading: SvgPicture.asset(AppImages.icLocation, 
        color: AppColors.PRIMARY_GREEN,),
      title: Paragraph(
        content: 'address',
        style: STYLE_SMALL_BOLD.copyWith(fontSize: SpaceBox.sizeMedium),
      ),
    );
  }

  Widget buildDivider(){
    return const Divider(
      color: AppColors.BLACK_300,
    );
  }

  Widget buildAppBar(){
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeLarge),
      child: const CustomerAppBar(
        title: '#LH000034',
      ),
    );
  }

  Widget buildHeader(){
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        boxShadow: [
          BoxShadow(blurRadius: SpaceBox.sizeMedium, color: AppColors.BLACK_300),
        ],
      ),
      child: Column(
        children: [
          buildAppBar(),
          buildDivider(),
          buildAddress(),
        ],
      ),
    );
  }

  Widget buildTitle({
    IconData? icon,
    String? content,
    Widget? trailing,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Paragraph(
              content: content ?? '',
              style: STYLE_MEDIUM_BOLD,
            ),
          ],
        ),
        trailing ?? Container(),
      ],
    );
  }

  Widget buildStatusCard(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: SpaceBox.sizeMedium),
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE, 
         boxShadow: [
          BoxShadow(blurRadius: SpaceBox.sizeMedium, color: AppColors.BLACK_300),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(
            content: 'Hom nay, 10: 30',
            trailing: const StatusService(
              content: 'Da xac nhan',
              color: AppColors.PRIMARY_GREEN,
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
            child: const ItemWidget(title:'Khach Hang' ,content: 'Ngan 98',),
          ),
          buildDivider(),
          const ItemWidget(
            title:  'Tam tinh',
            content: '300.000 vnd',
            color: AppColors.PRIMARY_GREEN,
            isSpaceBetween: true,
          ),
        ],
      ),
    );
  }

  Widget buildTitleService(){
    return const Paragraph(
      content: 'Thong tin dich vu (1)',
      style: STYLE_MEDIUM,
    );
  }

  Widget buildNoteService(){
    return Column(
      children: [
        Paragraph(
          content: 'Ghi chu',
          style: STYLE_LARGE_BOLD.copyWith(color: AppColors.PRIMARY_GREEN),
        ),
        const Paragraph(
          content: 'ghi chu',
          style: STYLE_MEDIUM,
        ),
      ],
    );
  }

  Widget buildService(){
    return Container(
      padding: EdgeInsets.all(SizeToPadding.sizeMedium),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE, 
        boxShadow: [
          BoxShadow(blurRadius: SpaceBox.sizeMedium, color: AppColors.BLACK_300),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleService(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
            child: const ItemWidget(
              content: '160.000d',
              title: 'Hon moi cung em',
              fontWeightTitle: FontWeight.bold,
              isSpaceBetween: true,
              color: AppColors.PRIMARY_GREEN,
            ),
          ),
          buildDivider(),
          buildNoteService(),
        ],
      ),
    );
  }

  Widget buildBookingDetailsScreen(){
    return SafeArea(
      top: true,
      left: false,
      bottom: false,
      right: false,
      child: Column(
        children: [
          buildHeader(),
          buildStatusCard(),
          buildService(),
        ],
      ),
    );
  }
}
