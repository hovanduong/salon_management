// ignore_for_file: use_late_for_private_fields_and_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../configs/configs.dart';
import '../../configs/constants/app_space.dart';
import '../../configs/language/invoice_language.dart';
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
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: buildInvoice(),
        );
      },
    );
  }

  Widget buildInvoice() {
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
      child: Paragraph(
        content: InvoiceLanguage.invoice,
        style: STYLE_LARGE_BOLD,
      )
    );
  }

  Widget invoiceUser(int index) {
    final money= _viewModel!.listFoundInvoice[index].total;
    final date= _viewModel!.listFoundInvoice[index].createdAt;
    final name= _viewModel!.listFoundInvoice[index].myBooking?.myCustomer?.fullName;
    return Transaction(
      color: _viewModel!.colors[index % _viewModel!.colors.length],
      money: '+ $money',
      subtile: date != null ? AppCheckTime.checkTimeNotification(date) : '',
      name: name ?? '',
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
        hintText: InvoiceLanguage.search,
        onChanged: (value) {
          _viewModel!.onSearchCategory(value);
        },
      ),
    );
  }

  Widget buildListInvoice(){
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
              ? _viewModel!.listFoundInvoice.length +1 
              : _viewModel!.listFoundInvoice.length,
            itemBuilder: (context, index) {
              if(index<_viewModel!.listFoundInvoice.length){
                return invoiceUser(index);
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
            BoxShadow(color: AppColors.BLACK_200, blurRadius: SpaceBox.sizeBig)
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildSearch(),
              buildListInvoice(),
            ],
          ),
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
