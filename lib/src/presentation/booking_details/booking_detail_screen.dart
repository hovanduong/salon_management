import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../utils/date_format_utils.dart';
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
    final id= ModalRoute.of(context)!.settings.arguments;
    return BaseWidget(
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(id.toString()),
      viewModel: BookingDetailsViewModel(), 
      builder: (context, viewModel, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: buildBookingDetailsScreen(),
        ),
    );
  }

  Widget buildAddress(int index){
    return ListTile(
      minLeadingWidth: SpaceBox.sizeSmall,
      leading: SvgPicture.asset(AppImages.icLocation, 
        color: AppColors.PRIMARY_GREEN,),
      title: Paragraph(
        content: _viewModel!.listMyBooking[index].address,
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
      child: CustomerAppBar(
        onTap: () => Navigator.pop(context),
        title: '#LH000034',
      ),
    );
  }

  Widget buildHeader(int index){
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
          buildAddress(index),
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

  Widget buildStatusCard(int index){
    final date = _viewModel!.listMyBooking[index].createdAt;
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
            content:  date,
            trailing: StatusService(
              content: _viewModel!.listMyBooking[index].status,
              color: AppColors.PRIMARY_GREEN,
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
            child: ItemWidget(
              title:'Khach Hang' ,
              content: _viewModel!.listMyBooking[index].myCustomer!.fullName,
            ),
          ),
          buildDivider(),
          ItemWidget(
            title:  'Tam tinh',
            content: _viewModel!.listMyBooking[index].total.toString(),
            color: AppColors.PRIMARY_GREEN,
            isSpaceBetween: true,
          ),
        ],
      ),
    );
  }

  Widget buildTitleService(int index){
    final lengthService= _viewModel!.listMyBooking[index].myServices!.length;
    return Paragraph(
      content: 'Thong tin dich vu ($lengthService)',
      style: STYLE_MEDIUM,
    );
  }

  Widget buildNoteService(int index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Paragraph(
          content: 'Ghi chu',
          style: STYLE_LARGE_BOLD.copyWith(color: AppColors.PRIMARY_GREEN),
        ),
        Paragraph(
          content: _viewModel!.listMyBooking[index].note,
          style: STYLE_MEDIUM,
        ),
      ],
    );
  }

  Widget buildListService(int index){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeMedium),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _viewModel!.listMyBooking[index].myServices?.length,
        itemBuilder: (context, indexService) {
          final money =_viewModel!.listMyBooking[index].myServices![indexService].money;
          final service =_viewModel!.listMyBooking[index].myServices![indexService].name;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVeryVerySmall),
            child: ItemWidget(
              content: money.toString(),
              title: service,
              fontWeightTitle: FontWeight.bold,
              isSpaceBetween: true,
              color: AppColors.PRIMARY_GREEN,
            ),
          );
        }
      ),
    );
  }

  Widget buildService(int index){
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
          buildTitleService(index),
          buildListService(index),
          buildDivider(),
          buildNoteService(index),
        ],
      ),
    );
  }

  Widget buildItemScreen(){
    return SafeArea(
      top: true,
      left: false,
      bottom: false,
      right: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _viewModel!.listMyBooking.length,
            itemBuilder: (context, index) => Column(
              children: [
                buildHeader(index),
                buildStatusCard(index),
                buildService(index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBookingDetailsScreen(){
    return StreamProvider<NetworkStatus>(
        initialData: NetworkStatus.online,
        create: (context) =>
            NetworkStatusService().networkStatusController.stream,
        child: NetworkAwareWidget(
          offlineChild: const ThreeBounceLoading(),
          onlineChild: Container(
            color: AppColors.COLOR_WHITE,
            child: Stack(
              children: [
                buildItemScreen(),
                if (_viewModel!.isLoading)
                  const Positioned(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: ThreeBounceLoading(),
                    ),
                  )
              ],
            ),
          ),
        ),
      );
  }
}