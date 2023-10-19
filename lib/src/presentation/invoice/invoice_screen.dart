// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/invoice_language.dart';
import '../../resource/service/my_booking.dart';
import '../../utils/app_currency.dart';
import '../../utils/check_time.dart';
import '../base/base.dart';
import 'components/components.dart';
import 'invoice_view_model.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  InvoiceViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<InvoiceViewModel>(
      viewModel: InvoiceViewModel(),
      onViewModelReady: (viewModel) => _viewModel = viewModel!..init(),
      builder: (context, viewModel, child) {
        // return AnnotatedRegion<SystemUiOverlayStyle>(
        //   value: const SystemUiOverlayStyle(
        //     statusBarColor: Colors.white,
        //     systemNavigationBarColor: Colors.white,
        //     statusBarIconBrightness: Brightness.dark,
        //     systemNavigationBarIconBrightness: Brightness.dark,
        //   ),
        //   child: buildInvoice(),
        return buildInvoice();
      },
    );
  }

  Widget buildInvoice() {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: SizeToPadding.sizeLarge * 3),
        child: FloatingActionButton(
          heroTag: 'addBooking',
          backgroundColor: AppColors.PRIMARY_GREEN,
          onPressed: () => _viewModel!.goToAddInvoice(context),
          child: const Icon(Icons.add),
        ),
      ),
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
                buildInvoiceScreen(),
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
        padding: EdgeInsets.only(top: Platform.isAndroid ? 20 : 40),
        child: ListTile(
          title: Center(
            child: Paragraph(
              content: InvoiceLanguage.invoice,
              style: STYLE_LARGE.copyWith(
                color: AppColors.COLOR_WHITE,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget invoiceUser(int index) {
    final money = _viewModel!.listCurrent[index].myBooking?.total;
    final date = _viewModel!.listCurrent[index].createdAt;
    final name = _viewModel!.listCurrent[index].myBooking?.myCustomer?.fullName;
    final idBooking = _viewModel!.listCurrent[index].myBookingId;
    final code = _viewModel!.listCurrent[index].code;
    return InkWell(
      onTap: () => _viewModel!.goToBookingDetails(
        context,
        MyBookingParams(id: idBooking, code: code, isInvoice: true),
      ),
      child: Transaction(
        color: _viewModel!.colors[index % _viewModel!.colors.length],
        money: '+ ${AppCurrencyFormat.formatMoneyVND(money??0)}',
        subtile: date != null ? AppCheckTime.checkTimeNotification(date) : '',
        name: name ?? '',
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
        hintText: InvoiceLanguage.search,
        onChanged: (value) {
          _viewModel!.onSearchCategory(value);
        },
      ),
    );
  }

  Widget buildListInvoice() {
    return RefreshIndicator(
      color: AppColors.PRIMARY_GREEN,
      onRefresh: () async {
        await _viewModel!.pullRefresh();
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 250,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _viewModel!.scrollController,
          itemCount: _viewModel!.loadingMore
              ? _viewModel!.listCurrent.length + 1
              : _viewModel!.listCurrent.length,
          itemBuilder: (context, index) {
            if (index < _viewModel!.listCurrent.length) {
              return invoiceUser(index);
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildSearch(),
            buildListInvoice(),
          ],
        ),
      ),
    );
  }

  Widget buildInvoiceScreen() {
    return Column(
      children: [
        buildHeader(),
        buildBody(),
      ],
    );
  }
}
