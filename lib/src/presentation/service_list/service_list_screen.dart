import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/service_list_language.dart';
import '../base/base.dart';

import 'components/added_service.dart';
import 'service_list_viewmodel.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  ServiceListViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ServiceListViewModel>(
      viewModel: ServiceListViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) => buildServiceList(),
    );
  }

  //NOTE: MAIN WIDGET
  Widget buildServiceList() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildAppbar(),
            buildAddedService(),
            buildAddedService(),
            buildAddedService(),
            buildAddedService(),
            buildAddedService(),
          ],
        ),
      ),
    );
  }

  Widget buildAppbar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeToPadding.sizeMedium,
        vertical: SizeToPadding.sizeMedium,
      ),
      child: CustomerAppBar(
        onTap: () => Navigator.pop(context),
        title: ServiceListLanguage.serviceList,
        rightIcon: IconButton(
          onPressed: () => _viewModel!.addService(),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildAddedService() {
    return AddedServiceWidget(
      svgPicture: SvgPicture.asset(AppImages.heartIcon),
      color: AppColors.PRIMARY_LIGHT_PINK,
      serviceTopic: 'Dinner',
      serviceDescription: 'Dinner at my house',
      serviceMoney: '100,000 VND',
      button: IconButton(
        icon: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 20,
        ),
        onPressed: () {
          _viewModel!.onServiceDetails(context);
        },
      ),
    );
  }
}
