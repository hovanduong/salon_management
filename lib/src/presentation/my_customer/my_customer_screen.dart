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
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: buildCustomerScreen(),
        );
      },
    );
  }

  Widget buildCustomerScreen() {
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
                buildMyCustomer(),
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
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: SpaceBox.sizeSmall),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        boxShadow: [
          BoxShadow(color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig)
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeToPadding.sizeSmall),
        child: CustomerAppBar(
          onTap: () {
            Navigator.pop(context);
          },
          title: MyCustomerLanguage.myCustomer,
        ),
      ),
    );
  }

  Widget buildInfoCustomer (int index) {
    final phone =_viewModel!.listMyCustomer[index].phoneNumber;
    final name = _viewModel!.listMyCustomer[index].fullName;
    return CardServiceWidget(
      phone: phone,
      name: name,
      onEdit: (context) => _viewModel!.goToMyCustomerEdit(
        context, _viewModel!.listMyCustomer[index]),
      // onDelete: (context) => _viewModel!.goToMyCustomerEdit(context),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: RefreshIndicator(
        color: AppColors.PRIMARY_GREEN,
        onRefresh: () async {
          await _viewModel!.pullRefresh();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.COLOR_WHITE,
            boxShadow: [
              BoxShadow(
                  color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig)
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: SizeToPadding.sizeMedium,
                left: SizeToPadding.sizeSmall,
                right: SizeToPadding.sizeVerySmall),
            child: ListView.builder(
              itemCount: _viewModel!.listMyCustomer.length,
              itemBuilder: (context, index) =>
                  buildInfoCustomer(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMyCustomer() {
    return SafeArea(
      child: Scaffold(
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
            )
          ],
        ),
      ),
    );
  }
}
