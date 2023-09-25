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
    final phone =_viewModel!.foundCustomer[index].phoneNumber;
    final name = _viewModel!.foundCustomer[index].fullName;
    final id = _viewModel!.foundCustomer[index].id;
    return Padding(
      padding: EdgeInsets.all(SizeToPadding.sizeVeryVerySmall),
      child: CardCustomerWidget(
        phone: phone,
        name: name,
        onEdit: (context) => _viewModel!.goToMyCustomerEdit(
          context, _viewModel!.foundCustomer[index]),
        onDelete: (context) => _viewModel!.showWaningDiaglog(id!),
      ),
    );
  }

  Widget buildSearch(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeMedium),
      child: AppFormField(
        iconButton: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
          color: AppColors.BLACK_300,
        ),
        hintText: MyCustomerLanguage.search,
        onChanged: (value) {
          _viewModel!.onSearchCategory(value);
        },
      ),
    );
  }

  Widget showListCustomer(){
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(
              left: SizeToPadding.sizeSmall,
              right: SizeToPadding.sizeVerySmall),
          height: MediaQuery.of(context).size.height-200,
          child: ListView.builder(
            controller: _viewModel!.scrollController,
            itemCount: _viewModel!.loadingMore
              ? _viewModel!.foundCustomer.length+1
              : _viewModel!.foundCustomer.length,
            itemBuilder: (context, index) {
              if(index<_viewModel!.foundCustomer.length){
                return buildInfoCustomer(index);
              }else{
                return const CupertinoActivityIndicator();
              }
            }
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.COLOR_WHITE,
          boxShadow: [
            BoxShadow(
              color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig)
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildSearch(),
              showListCustomer(),
            ],
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
