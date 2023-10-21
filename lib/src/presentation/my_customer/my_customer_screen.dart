// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/my_customer_language.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'my_customer.dart';

class MyCustomerScreen extends StatefulWidget {
  const MyCustomerScreen({super.key});

  @override
  State<MyCustomerScreen> createState() => _MyCustomerScreenState();
}

class _MyCustomerScreenState extends State<MyCustomerScreen> {
  MyCustomerViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<MyCustomerViewModel>(
      viewModel: MyCustomerViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: AppColors.PRIMARY_GREEN,
            systemNavigationBarColor: Colors.white,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: buildCustomerScreen(),
        );
      },
    );
  }

  Widget buildCustomerScreen() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                buildMyCustomer(),
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

  Widget buildHeader() {
    return Container(
      color: AppColors.PRIMARY_GREEN,
      child: Padding(
        padding: EdgeInsets.only(
          top: Platform.isAndroid ? 40 : 60,
          bottom: 10,
          left: SizeToPadding.sizeMedium,
        ),
        child: CustomerAppBar(
          color: AppColors.COLOR_WHITE,
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.COLOR_WHITE,
          ),
          onTap: () {
            Navigator.pop(context);
          },
          title: MyCustomerLanguage.myCustomer,
        ),
      ),
    );
  }

  Widget buildInfoCustomer(int index) {
    final phone = _viewModel!.listMyCustomer[index].phoneNumber;
    final name = _viewModel!.listMyCustomer[index].fullName;
    final id = _viewModel!.listMyCustomer[index].id;
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeVeryVerySmall),
      child: CardCustomerWidget(
        phone: phone,
        name: name,
        onEdit: (context) => _viewModel!.goToMyCustomerEdit(
          context,
          _viewModel!.listMyCustomer[index],
        ),
        onDelete: (context) => _viewModel!.showWaningDiaglog(id!),
      ),
    );
  }

  Widget buildSearch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeMedium),
      child: AppFormField(
        iconButton: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          color: AppColors.BLACK_300,
        ),
        hintText: MyCustomerLanguage.searchPhone,
        onChanged: (value) {
          _viewModel!.onSearchCategory(value);
        },
      ),
    );
  }

  Widget showListCustomer() {
    return _viewModel!.listMyCustomer.isEmpty & !_viewModel!.isLoading
        ? Padding(
            padding: EdgeInsets.only(top: SizeToPadding.sizeBig * 7),
            child: EmptyDataWidget(
              title: MyCustomerLanguage.emptyCustomer,
              content: MyCustomerLanguage.notificationEmptyCustomer,
            ),
          )
        : RefreshIndicator(
            color: AppColors.PRIMARY_GREEN,
            onRefresh: () async {
              await _viewModel!.pullRefresh();
            },
            child: Container(
              margin: EdgeInsets.only(
                left: SizeToPadding.sizeSmall,
                right: SizeToPadding.sizeVerySmall,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _viewModel!.scrollController,
                itemCount: _viewModel!.loadingMore
                    ? _viewModel!.listMyCustomer.length + 1
                    : _viewModel!.listMyCustomer.length,
                itemBuilder: (context, index) {
                  if (index < _viewModel!.listMyCustomer.length) {
                    return buildInfoCustomer(index);
                  } else {
                    return const CupertinoActivityIndicator();
                  }
                },
              ),
            ),
          );
  }

  Widget buildBody() {
    return Expanded(
      child: Column(
        children: [
          buildSearch(),
          Expanded(child: showListCustomer()),
        ],
      ),
    );
  }

  Widget buildMyCustomer() {
    return Scaffold(
      body: Column(
        children: [
          buildHeader(),
          buildBody(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingButtonWidget(
            heroTag: 'btn',
            iconData: Icons.add,
            onPressed: () {
              _viewModel!.goToAddMyCustomer(context);
            },
          ),
        ],
      ),
    );
  }
}
