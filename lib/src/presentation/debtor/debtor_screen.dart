// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/debit_language.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'debtor.dart';

class DebtorScreen extends StatefulWidget {
  const DebtorScreen({super.key});

  @override
  State<DebtorScreen> createState() => _DebtorScreenState();
}

class _DebtorScreenState extends State<DebtorScreen> {
  DebtorViewModel? _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      viewModel: DebtorViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) => buildLoading(),
    );
  }

  Widget buildLoading() {
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
                buildDebtor(),
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
          top: Platform.isAndroid ? 35 : 55,
          bottom: SizeToPadding.sizeVerySmall,
          left: SizeToPadding.sizeVerySmall,
        ),
        child: CustomerAppBar(
          onTap: () => Navigator.pop(context),
          title: DebitLanguage.debtor,
          color: AppColors.COLOR_WHITE,
          style: STYLE_LARGE.copyWith(
            color: AppColors.COLOR_WHITE,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget buildSearch() {
    return Showcase(
      description: DebitLanguage.searchDebitCustomer,
      key: _viewModel!.keySearch,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SpaceBox.sizeMedium),
        child: AppFormField(
          textEditingController: _viewModel!.searchController,
          iconButton: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: AppColors.BLACK_300,
          ),
          hintText: DebitLanguage.search,
          onChanged: (value) async {
            await _viewModel!.onSearchDebit(value.trim());
          },
        ),
      ),
    );
  }

  Widget buildCustomerDebtor(int index) {
    final id = _viewModel?.listCurrent[index].id;
    final name = _viewModel?.listCurrent[index].fullName;
    return InkWell(
      onTap: () => _viewModel!.goToDebt(
        myCustomerModel: _viewModel!.listCurrent[index],
      ),
      child: CardCustomerWidget(
        name: name,
        onTapDelete: (context) => _viewModel!.showWaningDiaglog(
          onTapRight: () => _viewModel!.deleteDebit(id!),
          title: DebitLanguage.waningDeleteCustomer,
        ),
        onTapUpdate: (context) => _viewModel!.showDialogAddDebit(
          context,
          idEdit: id,
          name: name,
        ),
      ),
    );
  }

  Widget buildIconEmpty() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(top: SizeToPadding.sizeBig * 7),
        child: EmptyDataWidget(
          title: DebitLanguage.debit,
          content: DebitLanguage.notificationDebitEmpty,
        ),
      ),
    );
  }

  Widget buildListDebtor() {
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: _viewModel!.listCurrent.isEmpty && !_viewModel!.isLoading
          ? buildIconEmpty()
          : Container(
              padding: EdgeInsets.only(
                left: SizeToPadding.sizeSmall,
                right: SizeToPadding.sizeVerySmall,
              ),
              height: MediaQuery.of(context).size.height - 170,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _viewModel!.scrollController,
                itemCount: _viewModel!.loadingMore
                    ? _viewModel!.listCurrent.length + 1
                    : _viewModel!.listCurrent.length,
                itemBuilder: (context, index) {
                  if (index < _viewModel!.listCurrent.length) {
                    return buildCustomerDebtor(index);
                  } else {
                    return const CupertinoActivityIndicator();
                  }
                },
              ),
            ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildSearch(),
        buildListDebtor(),
      ],
    );
  }

  Widget buildDebtor() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: SizeToPadding.sizeLarge * 3),
        child: Showcase(
          key: _viewModel!.keyAdd,
          description: DebitLanguage.addDebitCustomer,
          targetBorderRadius: BorderRadius.all(
            Radius.circular(
              BorderRadiusSize.sizeLarge,
            ),
          ),
          child: FloatingActionButton(
            heroTag: 'addBooking',
            backgroundColor: AppColors.PRIMARY_GREEN,
            onPressed: () => _viewModel!.showDialogAddDebit(context),
            child: const Icon(
              Icons.add,
              color: AppColors.COLOR_WHITE,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildBody(),
          ],
        ),
      ),
    );
  }
}
