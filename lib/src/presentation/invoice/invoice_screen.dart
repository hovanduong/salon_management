import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/homepage_language.dart';
import '../../utils/date_format_utils.dart';
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
        return buildInvoice();
      },
    );
  }

  Widget buildInvoice(){
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
                buildInvoiceScreen(),
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
      height: SpaceBox.sizeBig*2,
      width: double.maxFinite,
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: SpaceBox.sizeSmall),
      decoration: BoxDecoration(
        color: AppColors.COLOR_WHITE,
        boxShadow: [
          BoxShadow(color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig)
        ],
      ),
      child: const Paragraph(
        content: 'Hoa Don',
        style: STYLE_LARGE_BOLD,
      )
    );
  }

  Widget invoiceUser(int index) {
    final money= _viewModel!.listInvoice[index].total;
    final date= _viewModel!.listInvoice[index].createdAt;
    final name= _viewModel!.listInvoice[index].myBooking?.myCustomer?.fullName;
    return Transaction(
      money: '+ $money',
      subtile:  date != null
        ? AppDateUtils.splitHourDate(
            AppDateUtils.formatDateLocal(
              date,
            ),
          )
        : '',
      name: name??'',
    );
  }

  Widget buildBody() {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.COLOR_WHITE,
          boxShadow: [
            BoxShadow(color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig)
          ],
        ),
        child: ListView.builder(
          itemCount: _viewModel!.listInvoice.length,
          itemBuilder: (context, index) => invoiceUser(index),
        ),
      ),
    );
  }

  Widget buildInvoiceScreen() {
    return SafeArea(
      child: Column(
        children: [
          buildHeader(),
          buildBody(),
        ],
      ),
    );
  }
}
